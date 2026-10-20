const pool = require("../database/connection");

exports.findAvailableTerminalList = async ()=>{
    const query = `SELECT * FROM autoservicio.terminal_pago
                    WHERE activo = $1;`;
    const result = await pool.query(query,[true]);
    return result.rowCount>0? result.rows : [];

}



exports.findTransactionPayment = async  ({statusId,terminal})=>{

    const query = `SELECT 
                    pt.serial,
                    p.id as programmingId,
                    p.identificador as identifier,
                    p.fk_id_conector,
                    p.fk_id_pantalla,
                    p.programacion,
                    p.autorizado,
                    p.precio,
                    tp.id as transactionId,
                    tp.monto as amount,
                    tp.fk_id_estado_transaccion as statusId,
                    tp.fecha_registro,
                    c.id as connectorId,
                    c.posicion as position
                    FROM autoservicio.programacion as p
                    INNER JOIN autoservicio.transaccion_pago as tp
                    ON tp.fk_id_programacion = p.id
                    INNER JOIN autoservicio.pantalla as pt
                    ON pt.id = p.fk_id_pantalla
                    INNER JOIN autoservicio.conector as c
                    ON p.fk_id_conector = c.id
                    WHERE tp.fk_id_terminal_pago = $1 
                    AND tp.error_id = $2
                    AND tp.fk_id_estado_transaccion = $3`;
    const result = await pool.query(query,[terminal.id,0,statusId]);
    return result.rowCount>0? result.rows[0] : null;

}



exports.updateTransactionStatus = async (id,statusId, message) =>{

    let query = null;

    if(statusId === 6){
        query = `UPDATE autoservicio.transaccion_pago SET 
                    fk_id_estado_transaccion = $1,
                    peticion = $2,
                    fecha_registro = now()
                WHERE id = $3 RETURNING *;`;
    }else{

        query = `UPDATE autoservicio.transaccion_pago SET 
                    fk_id_estado_transaccion = $1,
                    respuesta = $2,
                    fecha_respuesta = now()
                WHERE id = $3 RETURNING *;`;
    }

   
    const result = await pool.query(query,[statusId,message,id]);
    return result.rowCount>0 ? result.rows[0] : null;
}



exports.findOverduePayment = async ()=>{

    const statusList = [1,4,6];

    const query = `SELECT * FROM autoservicio.transaccion_pago
                    WHERE fk_id_estado_transaccion = ANY($1::integer[])
                    AND fecha_registro < NOW() - INTERVAL '5 minutes';`;
    const result = await pool.query(query,[statusList]);
    return result.rowCount>0? result.rows : [];
}


exports.releasePaymentById = async (id) =>{
    const query = `UPDATE autoservicio.transaccion_pago SET 
                    fk_id_estado_transaccion = $1,
                    error_id = $2,
                    respuesta = $3,
                    fecha_respuesta = now()
                WHERE id = $4 RETURNING *;`;
    
    const result = await pool.query(query,[
        5,
        1, // Código de error 1
        {message: 'Transacción anulada por timeout de respuesta'},
        id]);

    return result.rowCount>0? result.rows[0] : null;
}