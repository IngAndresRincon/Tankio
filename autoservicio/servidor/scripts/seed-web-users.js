const crypto = require('crypto');
const path = require('path');
const dotenv = require('../src/node_modules/dotenv');
const { Pool } = require('../src/node_modules/pg');

dotenv.config({ path: path.resolve(__dirname, '../.env') });

const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  database: process.env.DB_DATABASE,
  ssl: String(process.env.DB_SSL || 'false').toLowerCase() === 'true'
    ? { rejectUnauthorized: false }
    : false,
});

const USERS = [
  { first_name: 'Carlos', last_name: 'Perez' },
  { first_name: 'Laura', last_name: 'Gomez' },
  { first_name: 'Andres', last_name: 'Rincon' },
  { first_name: 'Sofia', last_name: 'Castro' },
  { first_name: 'Daniel', last_name: 'Moreno' },
];

const ROLE_COLUMN_CANDIDATES = [
  'rol_id',
  'role_id',
  'user_role_id',
  'role',
  'id_role',
];

function escapeIdentifier(identifier) {
  return `"${String(identifier).replace(/"/g, '""')}"`;
}

function pickFirstExisting(columns, candidates) {
  const normalized = new Set(columns.map((column) => column.column_name));
  return candidates.find((candidate) => normalized.has(candidate)) || null;
}

async function tableExists(schema, table) {
  const query = `
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema = $1
      AND table_name = $2
    LIMIT 1;
  `;

  const result = await pool.query(query, [schema, table]);
  return result.rowCount > 0;
}

async function findRoleTable() {
  const query = `
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'web'
      AND (
        table_name ILIKE '%rol%'
        OR table_name ILIKE '%role%'
      )
    ORDER BY
      CASE
        WHEN table_name IN ('rol', 'role', 'roles') THEN 0
        ELSE 1
      END,
      table_name ASC;
  `;

  const result = await pool.query(query);

  for (const row of result.rows) {
    const exists = await tableExists('web', row.table_name);
    if (exists) {
      return row.table_name;
    }
  }

  return null;
}

async function getColumns(schema, table) {
  const query = `
    SELECT column_name, data_type, is_nullable, column_default
    FROM information_schema.columns
    WHERE table_schema = $1
      AND table_name = $2
    ORDER BY ordinal_position;
  `;

  const result = await pool.query(query, [schema, table]);
  return result.rows;
}

function makeEmail(index) {
  const seed = crypto.randomUUID().slice(0, 8);
  return `seed.user${index + 1}.${seed}@tankio.local`;
}

function makeValueMap(index, roleValue) {
  const user = USERS[index];

  return {
    email: makeEmail(index),
    username: `seed.user${index + 1}`,
    user_name: `seed.user${index + 1}`,
    name: `${user.first_name} ${user.last_name}`,
    full_name: `${user.first_name} ${user.last_name}`,
    first_name: user.first_name,
    firstname: user.first_name,
    last_name: user.last_name,
    lastname: user.last_name,
    password: 'Password123!',
    password_hash: 'Password123!',
    hash_password: 'Password123!',
    rol_id: roleValue,
    role_id: roleValue,
    user_role_id: roleValue,
    role: roleValue,
    is_active: true,
    active: true,
    status: 'active',
    created_at: new Date(),
    updated_at: new Date(),
    registration_date: new Date(),
  };
}

function resolveRoleValue(columnType, roleRow, fallbackIndex) {
  const roleId = roleRow?.id ?? roleRow?.role_id ?? roleRow?.code ?? roleRow?.name ?? null;
  const normalizedType = String(columnType || '').toLowerCase();

  if (['smallint', 'integer', 'bigint', 'numeric', 'decimal'].some((type) => normalizedType.includes(type))) {
    const numericRole = Number(roleId);
    if (Number.isFinite(numericRole)) {
      return numericRole;
    }

    return fallbackIndex + 1;
  }

  return roleId ? String(roleId) : `role-${fallbackIndex + 1}`;
}

function pickColumnValue(column, valueMap) {
  if (Object.prototype.hasOwnProperty.call(valueMap, column.column_name)) {
    return valueMap[column.column_name];
  }

  return undefined;
}

async function main() {
  const userColumns = await getColumns('web', 'user');
  if (userColumns.length === 0) {
    throw new Error('web.user table was not found');
  }

  const roleColumn = pickFirstExisting(userColumns, ROLE_COLUMN_CANDIDATES);
  const roleColumnInfo = roleColumn
    ? userColumns.find((column) => column.column_name === roleColumn)
    : null;

  const roleTableName = await findRoleTable();
  let roleRows = [];
  if (roleTableName) {
    const result = await pool.query(`SELECT * FROM web.${escapeIdentifier(roleTableName)} ORDER BY random() LIMIT 20;`);
    roleRows = result.rows;
  }

  const insertedUsers = [];

  for (let index = 0; index < USERS.length; index += 1) {
    const roleRow = roleRows.length > 0
      ? roleRows[index % roleRows.length]
      : null;

    const roleValue = roleColumn
      ? resolveRoleValue(roleColumnInfo?.data_type, roleRow, index)
      : null;

    const valueMap = makeValueMap(index, roleValue);
    const insertColumns = [];
    const insertValues = [];

    for (const column of userColumns) {
      const value = pickColumnValue(column, valueMap);
      if (value !== undefined) {
        insertColumns.push(column.column_name);
        insertValues.push(value);
      }
    }

    if (insertColumns.length === 0) {
      throw new Error('No compatible columns were found to insert into web.user');
    }

    const placeholders = insertColumns.map((_, idx) => `$${idx + 1}`).join(', ');
    const query = `
      INSERT INTO web.${escapeIdentifier('user')} (${insertColumns.map(escapeIdentifier).join(', ')})
      VALUES (${placeholders})
      RETURNING *;
    `;

    const result = await pool.query(query, insertValues);
    insertedUsers.push(result.rows[0]);
  }

  console.log(
    JSON.stringify(
      {
        inserted: insertedUsers.length,
        users: insertedUsers.map((user) => ({
          id: user.id,
          email: user.email,
          role_id: user.rol_id ?? user.role_id ?? user.user_role_id ?? user.role ?? null,
          name: user.name ?? user.full_name ?? `${user.first_name ?? ''} ${user.last_name ?? ''}`.trim(),
        })),
      },
      null,
      2
    )
  );
}

main()
  .catch((error) => {
    console.error('Seed failed:', error.message);
    process.exitCode = 1;
  })
  .finally(async () => {
    await pool.end().catch(() => {});
  });
