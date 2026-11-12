const pool = require("../../database/pg");


exports.findUserProgramming = async (data) =>{
 const query = `SELECT * FROM public.programacion
                WHERE fk_id_cliente = $1 AND fk_id_posicion = $2 AND fk_id_pantalla = $3 AND fk_id_venta IS NULL LIMIT 1;`;
    const result = await pool.query(query,[data.clientId,data.positionId,data.screenId]);
    return result.rowCount>0?result.rows[0]: null;   
}



exports.findPositionStatus = async (data) =>{
  const query = `SELECT * FROM public.estado
                  WHERE fk_id_posicion = $1 LIMIT 1;`;
  const result = await pool.query(query,[data.positionId]);
  return result.rowCount>0? result.rows[0]: null;
}



exports.findPendingProgrammingByUserId = async (userId,screenId)=>{
  const query = `SELECT * FROM public.programacion
                WHERE fk_id_cliente = $1 
                AND fk_id_pantalla = $2
                AND valor_abonado > 0  
                AND fk_id_venta IS NULL
                ORDER BY fecha_registro DESC LIMIT 1;`;
  const result = await pool.query(query,[userId,screenId]);
  return result.rowCount>0? result.rows[0] : null;
}


exports.findAuthorizationByProgramming = async (id) =>{
  const query = `SELECT * FROM public.autorizacion WHERE fk_id_programacion = $1;`;
  const result = await  pool.query(query,[id]);
  return result.rowCount>0 ? result.rows[0]:null;
}

exports.releasePendingProgramming = async(id)=>{
  const query = `UPDATE public.programacion SET
                  sincronizado = $1,
                  error = $2
                WHERE id = $3 RETURNING *;`;
  const result = await pool.query(query,[false,false,id]);
  return result.rowCount>0? result.rows[0]: null;
}

exports.findProgrammingById =async (programmingId) =>{
  const query = `SELECT * FROM public.programacion
                WHERE id = $1 AND fk_id_venta IS NULL LIMIT 1;`;
  const result = await pool.query(query,[programmingId]);
  return result.rowCount>0? result.rows[0] : null;
}


exports.authorizeprogramming  = async (programmingId) =>{
  const valorPendiente = 0; //Se deja en 0 para que se autorize el despacho, SOLO con el valor abonado.
  const idTipoProgramación = 2 // 2 Es programación en DINERO, 1 es programación en VOLUMEN
  const query = `UPDATE public.programacion SET 
    programacion = valor_abonado,
    valor_dinero = valor_abonado,
    valor_pendiente =$1,
    autorizado = $2,
    fk_id_tipo_programacion = $3
  WHERE id = $4 RETURNING *;`;
  const result = await pool.query(query,[valorPendiente,true,idTipoProgramación,programmingId]);
  return result.rowCount>0? result.rows[0]: null;
}


exports.createProgramming = async (data)=>{
 const query = `INSERT INTO public.programacion (
                fk_id_cliente,
                fk_id_posicion,
                fk_id_manguera,
                fk_id_producto,
                fk_id_pantalla,
                precio,
                programacion,
                fk_id_tipo_programacion,
                valor_abonado,
                valor_pendiente,
                valor_dinero)
              VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING *;`;
  const result = await pool.query(query,[
    data.clientId,
    data.positionId,
    data.hoseId,
    data.productId,
    data.screenId,
    data.price,
    data.programmingValue,
    data.programmingType,
    0,
    data.moneyValue,
    data.moneyValue
  ]);

  return result.rowCount>0 ? result.rows[0]: null;
}

exports.updateProgrammnig = async (data,programmingId) =>{
  const query = `UPDATE public.programacion SET
                  fk_id_manguera = $1,
                  fk_id_producto = $2,
                  precio = $3,
                  programacion = $4,
                  fk_id_tipo_programacion = $5,
                  valor_abonado= $6,
                  valor_pendiente = $7,
                  valor_dinero = $8,
                  autorizado = $9
                WHERE id = $10 RETURNING *;`;
  const result = await pool.query(query,[
    data.hoseId,
    data.productId,
    data.price,
    data.programmingValue,
    data.programmingType,
    0,
    data.moneyValue,
    data.moneyValue,
    false,
    programmingId
  ]);

  return result.rowCount>0? result.rows[0] : null;
}

exports.findPendingProgramming = async (data) =>{
    const query = `SELECT * FROM public.programacion 
    WHERE fk_id_cliente =$1 
    AND fk_id_posicion = $2 
    AND valor_abonado > $3 
    AND autorizado = $4 LIMIT 1;`;
    const result = await pool.query(query,[data.clientId,data.positionId,0,false]);
    return result.rowCount>0 ? result.rows[0]: null;
}


exports.findPendingPayment = async (data) =>{
  const query = `SELECT * FROM public.transaccion_pago 
  WHERE fk_id_programacion = $1 AND fk_id_estado_transaccion_pago NOT IN (2,3,5,7) LIMIT 1;`;
  const result = await pool.query(query,[data.programmingId]);
  return result.rowCount>0? result.rows[0] : null;
}


exports.createpayment = async (data) =>{
  const query = `INSERT INTO public.transaccion_pago 
  (fk_id_programacion,solicitud_payload,respuesta_payload,monto,fk_id_metodo_pago)
  VALUES ($1,$2,$3,$4,$5) RETURNING *;`;
  const result = await pool.query(query,[data.programmingId,data,data,data.amount,data.methodPaymentId]);
  return result.rowCount>0? result.rows[0]:null;
}


exports.findTransactionPaymentById = async (id)=>{
  const query = `SELECT * FROM public.transaccion_pago WHERE id = $1 LIMIT 1;`;
  const result = await pool.query(query,[id]);
  return result.rowCount>0? result.rows[0]: null;
}


exports.cancelPayment = async (data) =>{
  const query = `UPDATE public.transaccion_pago SET fk_id_estado_transaccion_pago = $1
  WHERE id = $2 RETURNING*;`;
  const result = await pool.query(query,[5, data.id]);
  return result.rowCount>0 ? true:false;
}


exports.lastSaleByTerminalId = async (id) =>{
  const query = `
              SELECT 
              v.id as idVenta,
              v.dinero,
              v.volumen,
              v.posicion,
              v.manguera,
              v.precio,
              pg.fk_id_producto as idproducto,
              p.nombre as producto,
              pg.fk_id_pantalla as idpantalla,
              pg.programacion,
              pg.fk_id_tipo_programacion as tipo_programacion,
              pg.valor_dinero,
              (pg.valor_dinero - v.dinero) as saldo,
              f.fk_id_estado_factura as invoicestatusid,
              f.solicitado as required,
              f.error,
			        f.cliente_payload as client,
              TO_CHAR(v.fecha_venta, 'YYYY-MM-DD HH24:MI:SS') as dateofsale
              FROM public.venta as v
              INNER JOIN public.programacion as pg
              ON v.id = pg.fk_id_venta
              INNER JOIN public.cliente as c
              ON pg.fk_id_cliente = c.id 
              INNER JOIN public.producto as p
              ON p.id = pg.fk_id_producto
              LEFT OUTER JOIN public.factura as f
              ON f.fk_id_venta = v.id
              WHERE fk_id_pantalla = $1 AND v.sincronizado >= $2
              ORDER BY v.fecha_venta DESC
              LIMIT 1;`;
  const result = await pool.query(query,[id,1]);
  return result.rowCount>0? result.rows[0]:null;
}



exports.lastsalebyprogramming = async (id) =>{
  const query = `
              SELECT 
              v.id as idVenta,
              v.dinero,
              v.volumen,
              v.posicion,
              v.manguera,
              v.precio,
              pg.fk_id_producto as idproducto,
              p.nombre as producto,
              pg.fk_id_pantalla as idpantalla,
              pg.programacion,
              pg.fk_id_tipo_programacion as tipo_programacion,
              pg.valor_dinero,
              (pg.valor_dinero - v.dinero) as saldo,
              f.fk_id_estado_factura as invoicestatusid,
              f.solicitado as required,
              f.error,
			        f.cliente_payload as client,
              TO_CHAR(v.fecha_venta, 'YYYY-MM-DD HH24:MI:SS') as dateofsale
              FROM public.venta as v
              INNER JOIN public.programacion as pg
              ON v.id = pg.fk_id_venta
              INNER JOIN public.cliente as c
              ON pg.fk_id_cliente = c.id 
              INNER JOIN public.producto as p
              ON p.id = pg.fk_id_producto
              LEFT OUTER JOIN public.factura as f
              ON f.fk_id_venta = v.id
              WHERE pg.id = $1 AND v.sincronizado >= $2
              ORDER BY v.fecha_venta DESC
              LIMIT 1;`;
  const result = await pool.query(query,[id,1]);
  return result.rowCount>0? result.rows[0]:null;
}



exports.availableproducts = async (id) =>{
  const query = `SELECT id,nombre,precio FROM public.producto 
  WHERE id <> $1 AND activo = $2;`;
  const result = await pool.query(query,[id,true]);
  return result.rowCount>0? result.rows:[];
}


exports.findAvailableHose = async (position,product)=>{
  const query = `SELECT m.*,p.precio,p.nombre as producto FROM public.manguera as m
                  INNER JOIN public.producto as p
                  ON m.fk_id_producto = p.id
                  WHERE fk_id_posicion = $1 AND fk_id_producto = $2 AND m.activo = $3 LIMIT 1;`;
  const result = await pool.query(query,[position,product,true]);
  return result.rowCount>0 ? result.rows[0]:null;
}



exports.changeProduct = async (programming, hose)=>{

  let progValue = programming.programacion;
  if(programming.fk_id_tipo_programacion ===3) {
//    progValue = Math.round(programming.valor_dinero/hose.precio);
    progValue = (programming.valor_dinero/hose.precio).toFixed(4);
    //progValue = progValue.toFixed(2);
  }

  

  const query = `UPDATE public.programacion SET 
                  fk_id_manguera = $1,
                  fk_id_producto = $2,
                  precio = $3,
                  programacion = $4
                WHERE id = $5 RETURNING *;`;
  const result = await pool.query(query,[
      hose.id,
      hose.fk_id_producto,
      hose.precio,
      progValue,
      programming.id
    ]);
  return result.rowCount>0? result.rows[0]: null;
}