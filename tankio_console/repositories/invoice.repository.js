const pool = require("../database/pg");


exports.getAvailableStationConfiguration = async ()  =>{
    const query = `SELECT * FROM public.station_invoice_configuration 
    WHERE active = $1 AND token_expire_at < now()`;
    const result = await pool.query(query,[true]);
    return result.rowCount>0? result.rows : [];
}   


exports.saveToken = async (record,response) =>{

    const expire_minutes = response.expires_in / 60;

    const query = `
    UPDATE public.station_invoice_configuration
    SET token_authentication = $1,
        token_expire_at = now() + ($2 * interval '1 minute')
    WHERE id = $3 RETURNING *;`;

    const result = await pool.query(query, [response,expire_minutes,record.id]);
    return result.rowCount>0? true:false;
}


exports.getListUnsynchronizedSales = async ()=>{
    const query = `
            SELECT 
            s.*,
            pg.id as programming_id,
            pg.station_id,
            pg.user_id,
            pg.identifier,
            pg.controller_id,
            pg.position_id,
            pg.hose_id,
            h.hose_number,
            h.hose_code,
            p.id as product_id,
            p.name as product_name,
            p.station_id as product_station_id,
            p.product_code,
            pg.price,
            pg.programming_type,
            pg.programming_value,
            pg.programming_money,
            pg.uuid as programming_uuid
            FROM public.sale as s
            INNER JOIN public.programming as pg
            ON s.programming_uuid = pg.uuid
            INNER JOIN public.hose as h 
            ON pg.hose_id = h.id
            INNER JOIN public.product as p
            ON h.product_id = p.id
            WHERE s.synchronized = $1;`;
    const result = await pool.query(query,[false]);
    return result.rowCount>0? result.rows : [];
}


exports.generateRecordInvoice = async (sale)=>{
    const user =await findUserById(sale.user_id);
    if(!user){
        return false;
    }

    const sequenceNumber = await findLastSequenceNumber(sale.station_id);
    if(!sequenceNumber){
        return false;
    }

    const registered = await createInvoiceRecord(sale,user,sequenceNumber);

    return registered;

}


async function findUserById(id){
    const query = `SELECT
    u.id as user_id,
    u.name,
    u.last_name,
    u.email,
    u.document_number,
    u.phone_number,    
    td.id as document_type_id,
    td.type as document,
    dian_code as document_type_code
    FROM public.user as u
    INNER JOIN type.document as td
    ON td.id = u.document_type_id
    WHERE u.id = $1 AND u.active = $2 LIMIT 1;`;
    const result = await pool.query(query,[id, true]);
    return result.rowCount>0? result.rows[0]:null;
}

async function findLastSequenceNumber(stationId){

    let recordSequence = null;

    const query = `SELECT * FROM public.station_invoice WHERE station_id = $1 LIMIT 1;`;
    const result = await pool.query(query,[stationId]);
    recordSequence = result.rowCount>0?result.rows[0]:null;

    if(!recordSequence){
        const query = `INSERT INTO public.station_invoice (station_id) VALUES($1) RETURNING *;`;
        const result = await pool.query(query,[stationId])
        recordSequence = result.rowCount>0? result.rows[0]:null;
    }

    return recordSequence;
}


async function createInvoiceRecord(sale,user,sequenceNumber){


    let query = `SELECT * FROM public.invoice WHERE sale_id = $1 LIMIT 1;`;
    const result0 = await pool.query(query,[sale.id]);
    const existsInvoice = result0.rowCount>0?true:false;

    if(existsInvoice) return existsInvoice;

    const sequenceValue = sequenceNumber.last_invoice +1;

    query = `INSERT INTO public.invoice 
                (station_id,
                invoice_sequence_number,
                sale_id,
                user_payload,
                sale_payload)
                VALUES($1,$2,$3,$4,$5) RETURNING *;`;
    const result = await pool.query(query,
    [sale.station_id,sequenceValue,sale.id,JSON.stringify(user),JSON.stringify(sale)]);
    return result.rowCount>0? true:false;
}

exports.confirmRecordCreation = async (record)=>{
    const query = `UPDATE public.sale SET synchronized = $1 
    WHERE id = $2 AND synchronized =$3 RETURNING *;`;
    const result = await pool.query(query,[true,record.id,false]);
    return result.rowCount>0 ? true:false;
}

exports.incrementSequenceValue = async (record) =>{
    const query = `UPDATE public.station_invoice 
    SET last_invoice = last_invoice+1, modified_at = now()
    WHERE station_id =$1 RETURNING *;`;
    const result = await pool.query(query,[record.station_id]);
    return result.rowCount>0? true:false;
}


exports.getListUnprocessedInvoices= async (statusCode) =>{
    const query = `SELECT * FROM public.invoice WHERE status_code_invoice = $1;`;
    const result = await pool.query(query,[statusCode]);
    return result.rowCount>0? result.rows : [];
}


exports.getTaxesByProduct = async (productId) =>{
    const query = `SELECT 
                    pt.id as product_tax_id,
                    pt.product_id,
                    pt.percentage_value,
                    pt.active,
                    t.tax,
                    t.tax_code,
                    t.description
                    FROM public.product_tax as pt
                    INNER JOIN public.tax as t
                    ON pt.tax_id = t.id 
            WHERE pt.product_id = $1 AND pt.active = $2;`;
    const result = await pool.query(query,[productId,true]);
    return result.rowCount? result.rows :[];
}


exports.savePayloadRequestInvoice = async(item,payload)=>{
    const query = `UPDATE public.invoice 
    SET request_invoice_payload = $1, 
        modified_at = now(),
        status_code_invoice = $2
    WHERE id = $3 RETURNING *;`;
    const result = await pool.query(query,[payload,1,item.id]);
    return result.rowCount>0? true : false;
}

exports.getStationInvoiceConfiguration = async (stationId)=>{
    const query = `SELECT * FROM public.station_invoice_configuration 
    WHERE station_id = $1 AND active = $2 LIMIT 1;`;
    const result = await pool.query(query,[stationId,true]);
    return result.rowCount>0 ? result.rows[0] : null;
}