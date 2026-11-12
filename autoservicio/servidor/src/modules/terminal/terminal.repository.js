const pool = require("../../database/pg");



exports.findTerminalActive = async (serial)=>{
  const query = `SELECT * FROM public.datafono WHERE TRIM(serial) = TRIM($1) AND activo = $2 LIMIT 1;`; 
  const result = await pool.query(query,[serial,true]);
  return result.rowCount>0? result.rows[0]:null;
}


exports.updateTerminalData = async(id,payload) =>{
  const query = `UPDATE public.datafono SET 
                  password = $1,
                  ip = $2,
                  numterminal = $3,
                  fecha_registro = now()
                WHERE id = $4 RETURNING *;`;
  const result = await pool.query(query,[payload.serial,payload.ip,payload.side,id]);
  return result.rowCount>0? result.rows[0] : null;
}