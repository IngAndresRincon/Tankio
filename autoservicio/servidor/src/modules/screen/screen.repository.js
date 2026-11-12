const pool = require("../../database/pg");



exports.findActiveScreen = async (data) =>{
    const query = `SELECT * FROM public.pantalla 
    WHERE id = $1 AND TRIM(password) = $2 AND activo = $3 LIMIT 1;`;
    const result = await pool.query(query,[data.id,data.identifier, true]);
    return result.rowCount>0 ? result.rows[0]: null;
}


exports.findScreen = async (data) => {
  const query = `SELECT 
    id,
    serial,
    password,
    ip,
    activo
  FROM public.pantalla 
  WHERE TRIM(serial) = $1 AND TRIM(password) = $2 AND activo = $3 LIMIT 1;`;
  const result = await pool.query(query,[data.identifier,data.password, true]);
  return result.rowCount>0 ? result.rows[0]: null;
};



exports.findScreenConfiguration =async (screen) =>{
  const query = `SELECT configuracion FROM public.pantalla_configuracion WHERE fk_id_pantalla = $1 LIMIT 1;`;
  const result =await pool.query(query,[screen.id]);
  return result.rowCount>0? result.rows[0] : null;
}


exports.updateScreenConfiguration = async (screen, ip)=>{
  const query = `UPDATE public.pantalla SET ip = $1, fecha_configuracion = NOW()
    WHERE id = $2 RETURNING *;`;
  const result = await pool.query(query,[ip,screen.id]);
  return result.rowCount>0? true:false;
}


exports.screenLogin = async (id,token)=>{
  const query = `INSERT INTO public.pantalla_sesion (fk_id_pantalla,token) 
  VALUES($1,$2) RETURNING *;`;
  const result = await pool.query(query,[id,token]);
  return result.rowCount>0? true:false;
}