const pool = require("../database/connection");

exports.findAuthorizedProgramming = async ()=>{
    const query = `SELECT 
                    p.id,
                    p.identificador,
                    p.fk_id_pantalla,
                    p.precio,
                    p.programacion,
                    p.valor_abonado,
                    p.valor_pendiente,
                    p.autorizado,
                    p.uuid,
                    p.fecha_registro,
                    p.sincronizado,
                    c.id as id_conector,
                    c.posicion,
                    c.manguera,
                    c.color,
                    pro.producto,
                    pro.precio as precio_product
                    FROM  autoservicio.programacion as p
                    INNER JOIN autoservicio.conector as c
                    ON p.fk_id_conector = c.id
                    INNER JOIN autoservicio.producto as pro
                    ON pro.id = c.fk_id_producto
                    WHERE p.autorizado = $1 AND p.sincronizado = $2 LIMIT 1;`;
    const result = await pool.query(query,[true,false]);
    return result.rowCount>0? result.rows[0] :null;

}


exports.findPresetAuthorizarionById = async (id)=>{
    const query = `SELECT * FROM autoservicio.autorizacion 
    WHERE fk_id_programacion = $1 LIMIT 1;`;
    const result = await pool.query(query,[id]);
    return result.rowCount>0? result.rows[0]: null;
}



exports.createPresetAuthorization = async ({programming}) =>{


    const power =parseInt(((programming.programacion*1000)/programming.precio).toFixed(2));


    const query = `INSERT INTO autoservicio.autorizacion (
                    fk_id_programacion,
                    fk_id_conector,
                    posicion,
                    manguera,
                    precio,
                    potencia,
                    programacion)
                VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *;`;
    const result = await pool.query(query,[
        programming.id,
        programming.id_conector,
        programming.posicion,
        programming.manguera,
        programming.precio,
        power,
        programming.programacion
    ]);

    return result.rowCount>0? result.rows[0] : null;
}


exports.synchronizeProgramming = async (id)  =>{
    const query = `UPDATE autoservicio.programacion SET
                    sincronizado = $1,
                    fecha_actualizacion = now()
                WHERE id = $2 AND sincronizado = $3 RETURNING *;`;
    const result = await pool.query(query,[true,id,false]);
    return result.rowCount>0? result.rows[0] : null;
}