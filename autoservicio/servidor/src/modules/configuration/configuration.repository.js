const pool = require("../../database/pg");



exports.findproducts = async ()=>{
  const query = `SELECT * FROM public.producto`; 
  const result = await pool.query(query);
  return result.rowCount>0? result.rows:[];
}

exports.updateproduct = async (id,payload)=>{
  const query = `UPDATE public.producto SET 
                  nombre = $1,
                  precio =$2,
                  activo = $3,
                  fecha_actualizado = now()
                WHERE id =$4 RETURNING *;`;
  const result = await pool.query(query,[
    payload.nombre,
    payload.precio,
    payload.activo,
    id,
  ]);
  return result.rowCount>0? result.rows[0]:null;
}

exports.findpaymentmethods = async(screenId)=>{
  const query = `SELECT 
        mp.id,
        mp.fk_id_posicion,
        mp.metodo_pago,
        mp.color,
        mp.titulo,
        mp.imagen,
        mp.activo
        FROM public.metodo_pago as mp
        INNER JOIN public.pantalla_posicion as pp
        on mp.fk_id_posicion = pp.fk_id_posicion
        WHERE pp.fk_id_pantalla = $1;`;
  const result = await pool.query(query,[screenId]);
  return result.rowCount>0? result.rows : [];
}


exports.updatepaymentmethod = async(paymentMethodId,paylod)=>{
  const query = `UPDATE public.metodo_pago SET 
                  activo = $1,
                  fecha_registro=now()
                WHERE id = $2 AND fk_id_posicion = $3 RETURNING *;`;
  const result = await pool.query(query,[paylod.activo,paymentMethodId,paylod.fk_id_posicion]);
  return result.rowCount>0? result.rows[0] :null;
}



exports.changevideo = async (screenId,videoName,extension)=>{
  const query = `UPDATE public.pantalla_configuracion SET 
                  video = $1,
                  fecha_actualizacion = now(),
                  sincronizar = $2,
                  formato_video = $4
                WHERE fk_id_pantalla = $3 AND activo = true RETURNING *;`;
  const result = await pool.query(query,[videoName,true,screenId,extension]);
  return result.rowCount>0? result.rows[0] : null;
}
