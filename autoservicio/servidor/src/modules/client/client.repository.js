const pool = require("../../database/pg");

exports.findClientByIdentifier = async (identifier) => {
  const query = `SELECT * FROM public.cliente
    WHERE identificador = $1 AND activo = $2 LIMIT 1;`;
  const result = await pool.query(query, [identifier, true]);
  return result.rowCount > 0 ? result.rows[0] : null;
};

exports.registerDefaultClient = async (identifier) => {
  const query = `INSERT INTO public.cliente (identificador,commodo) VALUES($1,$2) RETURNING *;`;
  const result = await pool.query(query, [identifier, false]);
  return result.rowCount > 0 ? result.rows[0] : null;
};

exports.registerNewClientDIAN = async (client) => {
  const { arrayName, arrayLastName } = generateClientName(client);
  const documentTypeId =await  findDocumentType(client.TipoDocIdAdquiriente);
  const query = `INSERT INTO public.cliente
    (identificador,fk_id_tipo_documento,numero_documento,nombre,apellido,correo,commodo) 
    VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *;`;
  const result = await pool.query(query, [
    client.NumIdAdquiriente,
    documentTypeId,
    client.NumIdAdquiriente,
    arrayName,
    arrayLastName,
    client.CorreoAdquiriente??'sininformacion@correo.com',
    false,
  ]);
  return result.rowCount > 0 ? result.rows[0] : null;
};


async function findDocumentType(document){
    const query = `SELECT id FROM public.tipo_documento 
                    WHERE LOWER(TRIM(descripcion)) = LOWER(TRIM($1)) LIMIT 1;`;
    const result = await pool.query(query,[document]);
    return result.rowCount>0? result.rows[0]['id']:0;
}

exports.updateCustomerDetails = async (id, client) => {
  const { arrayName, arrayLastName } = generateClientName(client);

  const query = `UPDATE public.cliente SET
                numero_documento = $1,
                nombre = $2,
                apellido = $3,
                correo = $4
            WHERE id = $5 RETURNING *`;
  const result = await pool.query(query, [
    client.NumIdAdquiriente,
    arrayName,
    arrayLastName,
    client.CorreoAdquiriente,
    id,
  ]);
  return result.rowCount > 0 ? result.rows[0] : null;
};

function generateClientName(client) {
  let arrayFullName = null;

  let arrayName = `CONSUMIDOR`;
  let arrayLastName = `FINAL`;

  if (client.NombreAdquiriente) {
    arrayFullName = client.NombreAdquiriente.split(" ");
    switch (arrayFullName.length) {
      case 0:
        arrayName = "CONSUMIDOR";
        arrayLastName = "FINAL";
        break;
      case 1:
        arrayName = "CONSUMIDOR";
        arrayLastName = arrayFullName[0];
        break;
      case 2:
        arrayName = arrayFullName[1];
        arrayLastName = arrayFullName[0];
        break;
      case 3:
        arrayName = `${arrayFullName[2]}`;
        arrayLastName = `${arrayFullName[0]} ${arrayFullName[1]}`;
        break;
      case 4:
        arrayName = `${arrayFullName[2]} ${arrayFullName[3]}`;
        arrayLastName = `${arrayFullName[0]} ${arrayFullName[1]}`;
        break;
      default:
        break;
    }
  }

  return { arrayName, arrayLastName };
}

exports.recordClientValidation = async (id) => {
  const query = `UPDATE public.cliente SET ultima_fecha_ingreso = now () WHERE id = $1 RETURNING *;`;
  const result = await pool.query(query, [id]);
  return result.rowCount > 0 ? result.rows[0] : null;
};

exports.findDinamicCode = async (code) => {
  const query = `SELECT * FROM public.cliente WHERE TRIM(identificador) = TRIM($1) AND activo = $2 LIMIT 1;`;
  const result = await pool.query(query, [code, true]);
  return result.rowCount > 0 ? result.rows[0] : null;
};
