const pool = require("../../database/pg");


exports.findScreenBySerial = async (serial) => {
  const query = `SELECT 
                  p.id,
                  p.serial,
                  p.password,
                  p.ip,
                  p.activo,
                  pp.fk_id_posicion
                  FROM public.pantalla as p
                  INNER JOIN public.pantalla_posicion as pp
                  ON p.id = pp.fk_id_pantalla
  WHERE TRIM(p.serial) = $1 AND p.activo = $2 LIMIT 1;`;
  const result = await pool.query(query,[serial,true]);
  return result.rowCount>0? result.rows[0] : null;
};

exports.findHosesByScreenId = async (screenId) => {
  const query = `SELECT
                  m.id,
                  m.idglobal,
                  m.fk_id_posicion,
                  m.manguera,
                  m.fk_id_producto,
                  p.nombre as producto,
                  p.precio,
                  m.codigo,
                  m.lado,
                  m.unidad_medida,
                  m.color,
                  m.valormax,
                  m.valormin,
                  m.activo,
                  pp.fk_id_pantalla
                  FROM public.manguera as m
                  INNER JOIN public.producto as p
                  ON m.fk_id_producto = p.id AND p.activo = $2
                  INNER JOIN public.pantalla_posicion as pp
                  ON pp.fk_id_posicion = m.fk_id_posicion
                WHERE pp.fk_id_pantalla =$1 AND m.activo = $2;`;
  const result = await pool.query(query,[screenId,true]);
  return result.rowCount>0? result.rows : null;
};



exports.findPaymentMethodsByPosition = async (positionId) =>{
  const query = `SELECT * FROM public.metodo_pago WHERE fk_id_posicion = $1 AND activo = $2;`;
  const result = await pool.query(query,[positionId,true]);
  return result.rowCount>0? result.rows : []
}

exports.findSpeedDialOptionsByPosition = async (positionId) =>{
  const query = `SELECT * FROM public.marcacion_rapida WHERE fk_id_posicion = $1 AND activo = $2;`;
  const result = await pool.query(query,[positionId,true]);
  return result.rowCount>0? result.rows : []
}


