const pool = require("../database/pg");
const { createHttpError } = require("../../common/http-error");



exports.getUserByEmail = async (email)=>{
  const query = `SELECT * FROM web.user WHERE email = $1 LIMIT 1;`;
  const result = await pool.query(query,[email]);
  return result.rowCount>0 ? result.rows[0]: null;
}

exports.getGroupsByUser = async (userId) =>{
  const query = `SELECT 
                  g.id as group_id,
                  g.name as group_name,
                  g.company_name,
                  wug.active,
                  wug.create_at
                  FROM  web.user_group as wug
                  INNER JOIN public.group as g
                  ON wug.group_id = g.id
                WHERE wug.user_id = $1 AND wug.active = $2;`;
  const result = await pool.query(query,[userId,true]);
  return result.rowCount>0 ? result.rows: [];
}

exports.getlistuser = async (id)=>{
  const query = `SELECT * FROM web.user WHERE id <> $1;`;
  const result = await pool.query(query,[id]);
  return result.rowCount>0 ? result.rows: [];
}



exports.findEmailUserActive =async (email)=>{
  const query = `SELECT id FROM web.user WHERE TRIM(email) = $1 AND active = $2 LIMIT 1;`;
  const result = await pool.query(query,[email,true]);
  return result.rowCount>0? result.rows[0] : null;
}

exports.findEmailAnotherUser =async (id, email)=>{
  const query = `SELECT id FROM web.user WHERE TRIM(email) = $1 AND active = $2 AND id <> $3 LIMIT 1;`;
  const result = await pool.query(query,[email,true,id]);
  return result.rowCount>0? result.rows[0] : null;
}



exports.createuser = async (payload)=>{
  const query = `INSERT INTO web.user (rol_id,name,last_name,email,phone_number,password) VALUES($1,$2,$3,$4,$5,$6) RETURNING *;`;
  const result = await pool.query(query,[payload.rolid,payload.name,payload.lastname,payload.email,payload.phonenumber,payload.password]);
  return result.rowCount>0 ? result.rows[0]: null;
}


exports.edituser = async (id,payload)=>{
  const query = `UPDATE web.user 
                  SET rol_id = $1,
                      name = $2,
                      last_name =$3,
                      email = $4,
                      phone_number = $5,
                      password =$6
                  WHERE id = $7 RETURNING *;`;
  const result = await pool.query(query,[payload.rolid,payload.name,payload.lastname,
    payload.email,payload.phonenumber,payload.password,id]);
  return result.rowCount>0 ? result.rows[0]: null;
}




exports.getuserstankioapp = async ()=>{
  const query = `
 SELECT
      u.*,
	  d.type as document_type,
      jsonb_build_object(
        'balance',
        COALESCE(
          sb.balance,
          '[]'::jsonb
        )
      ) AS balance
    FROM public.user AS u
	INNER JOIN type.document as d
	ON d.id = u.document_type_id
    LEFT JOIN LATERAL (
      SELECT jsonb_agg(
        jsonb_build_object(
          'balance_id', b.id,
          'balance', ROUND(b.balance_amount),
          'balance_uuid', b.uuid,
          'last_move_date', TO_CHAR(b.last_move_date, 'YYYY-MM-DD HH24:MI:SS'),
          'group', jsonb_build_object(
            'group_id', g.id,
            'group_name', g.name,
            'company_name', g.company_name,
            'address', g.address,
            'prefix_code', g.prefix_code
          )
        )
        ORDER BY b.id
      ) AS balance
      FROM public.balance AS b
      INNER JOIN public.group AS g
        ON g.id = b.group_id	 
      WHERE b.user_id = u.id AND b.active = true) AS sb ON true
    ORDER BY u.id DESC;`;
  const result = await pool.query(query);
  return result.rowCount>0 ? result.rows: [];
}



