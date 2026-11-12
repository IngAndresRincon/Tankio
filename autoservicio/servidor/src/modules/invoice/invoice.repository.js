const pool = require("../../database/pg");



exports.requestAnInvoice = async (saleId)=>{
  const query = `UPDATE public.factura SET
                  solicitado = $1,
                  error = $2,
                  fk_id_estado_factura = $3
                WHERE fk_id_venta = $4 RETURNING *;`; 
  const result = await pool.query(query,[true,false,0,saleId]);
  return result.rowCount>0? result.rows[0]:null;
}


exports.findInvoiceNotSent = async (saleId)=>{
  const query = `SELECT * FROM public.factura WHERE 
                  fk_id_venta = $1 LIMIT 1;`;
  const result = await pool.query(query,[saleId]);
  return result.rowCount>0? result.rows[0] : null;
}


exports.findDocumentTypeById = async (documentTypeId)=>{
  const query = `SELECT codigo FROM public.tipo_documento WHERE activo = $1 AND id = $2;`;
  const result = await pool.query(query,[true, documentTypeId]);
  return result.rowCount>0? result.rows[0]: null;
}


exports.updateCustomerDetails = async(saleId,payload)=>{
  const query = `UPDATE public.factura SET 
                  cliente_payload = $1, 
                  solicitado = $2,
                  error = $3,
                  fecha_actualizacion = now()
                WHERE fk_id_venta = $4 AND fk_id_estado_factura = $5 RETURNING *;`;
  const result = await pool.query(query,[payload,true,false,saleId,0]);
  return result.rowCount>0? result.rows[0]:null;
}

exports.defaultInvoice = async(saleId,payload)=>{
  const query = `UPDATE public.factura SET 
                  cliente_payload = $1,
                  solicitado = $2,
                  fecha_actualizacion = now()
                WHERE fk_id_venta = $3 AND fk_id_estado_factura = $4 RETURNING *;`;
  const result = await pool.query(query,[payload,true,saleId,0]);
  return result.rowCount>0? result.rows[0]:null;
}
 exports.findStation = async()=>{
  const query = `SELECT * FROM public.estacion LIMIT 1;`;
  const result = await pool.query(query);
  return result.rowCount>0? result.rows[0]:null;
 }

 exports.findPaymentMethods = async(saleId)=>{
  const query = `SELECT 
                  p.fk_id_posicion,
                  tp.fk_id_programacion,
                  mp.metodo_pago,
                  tp.monto,
                  tp.solicitud_payload,
                  tp.respuesta_payload,
                  tp.fk_id_estado_transaccion_pago,
                  tp.error,
                  tp.fecha_registro
                  FROM public.programacion as p
                  INNER JOIN public.transaccion_pago as tp
                  ON p.id = tp.fk_id_programacion
                  INNER JOIN public.metodo_pago as mp
                  ON mp.id = tp.fk_id_metodo_pago AND mp.fk_id_posicion = p.fk_id_posicion AND mp.activo = true
                WHERE fk_id_venta = $1 AND tp.fk_id_estado_transaccion_pago = $2;`;
  const result = await pool.query(query,[saleId, 2]);
  return result.rowCount>0? result.rows: [];
 }


 exports.findSaleById = async(saleId)=>{
  const query = `SELECT 
                p.id as id_programacion,
                v.id as id_venta,
                TO_CHAR(v.fecha_venta, 'YYYY-MM-DD HH24:MI:SS') as fecha_venta,
                v.dinero,
                v.volumen,
                pr.nombre as producto,
                v.posicion,
                v.precio,
                p.fk_id_cliente,
                p.fk_id_manguera,
                p.fk_id_producto,
                p.fk_id_pantalla,
                p.precio,
                p.programacion,
                p.valor_dinero,
                tp.tipo as tipo_programacion,
                c.identificador,
                CONCAT(c.nombre,' ',c.apellido) as nombre,
                (p.valor_dinero - v.dinero) as saldo
                FROM public.programacion as p
                INNER JOIN public.venta as v
                ON p.fk_id_venta = v.id
                INNER JOIN public.producto as pr
                ON pr.id = p.fk_id_producto
                INNER JOIN public.tipo_programacion as tp
                ON tp.id = p.fk_id_tipo_programacion
                INNER JOIN public.cliente as c
                ON c.id = p.fk_id_cliente
                WHERE v.id = $1 LIMIT 1;`;
  const result = await pool.query(query,[saleId]);
  return result.rowCount>0? result.rows[0]: null;
 }


 exports.savePrintSale = async(rows)=>{
  const query = `INSERT INTO public.impresion (filas) VALUES ($1) RETURNING *;`;
  const result = await pool.query(query,[rows]);
  return result.rowCount>0? result.rows[0]: null;
 }