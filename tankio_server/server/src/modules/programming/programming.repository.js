const pool = require("../../database/pg");
const { createHttpError } = require("../../common/http-error");


exports.createprogramming = async (data) => {

  const validPending = await validPendingProgramming(data);
  if(validPending){
      const error = new Error('Programming already exists');
      error.statusCode = 409;
      error.code = '';
      throw error;
  }

  const programming = await createProgramming(data);

  return programming;

};


exports.getprogrammingbyuser = async (data) => {

  const programming = await programmingbyuserid(data);
  if(programming.length == 0){
      const error = new Error('Programming records not found');
      error.statusCode = 404;
      error.code = '';
      throw error;
  }

  return programming;

};



exports.changestatusprogramming = async (id,status) => {

  const query = `UPDATE public.programming SET programming_status_id = $1 WHERE uuid =$2 RETURNING *;`;
  const response = await pool.query(query,[status,id]);
  return response.rows[0]|| null;

};



exports.findProgramminguuid = async (uuid) =>{
  const query = `SELECT id FROM public.programming WHERE uuid = $1 LIMIT 1;`;
  const result = await pool.query(query,[uuid]);
  return result.rowCount>0 ? result.rows[0] : null;
}

async function programmingbyuserid(id){
  const query = `
                SELECT 
                pg.id as programming_id,
                pg.station_id,
                s.name as station_name,
                s.latitude,
                s.longitude,
                s.station_type_id,
                s.address,
                pg.user_id,
                pg.identifier,
                vm.model as vehicle_model,
                vb.brand as vehicle_brand,
                pg.controller_id,
                pg.position_id,
                pg.hose_id,
                h.hose_number,
                h.hose_code,
                pd.id as product_id,
                pd.name as product_name,
                pd.product_code,
                pd.color,
                pg.price,
                pg.programming_type,
                pg.programming_value,
                pg.programming_money,
                pg.programming_status_id,
                tps.status,
                tps.description,
                pg.balance,
                pg.system_id,
                sys.system_name,
                pg.source_id,
                pg.booking,
                pg.uuid,
                TO_CHAR(pg.registration_date,'YYYY-MM-DD HH24:MI:SS') as registration_date
                FROM public.programming as pg
                INNER JOIN public.station as s
                ON pg.station_id = s.id
                INNER JOIN public.hose as h
                ON pg.hose_id = h.id
                INNER JOIN public.product as pd
                ON h.product_id = pd.id
                INNER JOIN public.vehicle as v
                ON v.user_id = pg.user_id AND TRIM(v.plate) = TRIM(pg.identifier)
                INNER JOIN type.vehicle_model as vm
                ON v.vehicle_model_id = vm.id
                INNER JOIN type.vehicle_brand as vb
                ON vm.brand_id = vb.id
                INNER JOIN type.system as sys
                ON sys.id = pg.system_id
                INNER JOIN type.programming_status as tps
                ON tps.id = pg.programming_status_id
                WHERE pg.user_id =$1 AND pg.active = true
                ORDER BY pg.registration_date DESC`;
    const result = await pool.query(query,[id]);
    return result.rowCount>0 ? result.rows : [];
}


async function validPendingProgramming(data) {

  const query = `SELECT id FROM public.programming
                  WHERE station_id = $1 AND user_id = $2 AND controller_id = $3 AND position_id = $4  AND programming_status_id IN (0,1,2,3) LIMIT 1;`;
  const result = await pool.query(query,[data.stationid,data.userid,
    data.controllerid,data.positionid]);
  return result.rowCount>0? result.rows[0] : null;

}

async function createProgramming(data){
  const query = `INSERT INTO public.programming(
                  station_id, user_id, identifier, controller_id, position_id, hose_id, price, programming_type, programming_value, programming_money, programming_status_id, balance, system_id, source_id, local_payment, booking)
                  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16) RETURNING *;`;
  const result = await pool.query(query,[data.stationid,data.userid,data.identifier,data.controllerid,data.positionid,data.hoseid,data.price,data.programmingtype,data.programmingvalue,data.programmingmoney,0,data.balance,data.systemid,data.sourceid,data.localpayment,data.booking]);
  return result.rowCount>0 ? result.rows[0] : null;
}


exports.getactivitybyuser= async (id) =>{
  const activity = await getactivitybyuser(id);
  if(activity.length == 0){
      const error = new Error('Programming records not found');
      error.statusCode = 404;
      error.code = '';
      throw error;
  }

  return activity;
}




async function getactivitybyuser(id){
  const query = `
                SELECT 
                pg.id as programming_id,
                pg.station_id,
                s.name as station_name,
                s.latitude,
                s.longitude,
                s.station_type_id,
                s.address,
                pg.user_id,
                pg.identifier,
                vm.model as vehicle_model,
                vb.brand as vehicle_brand,
                pg.controller_id,
                pg.position_id,
                pg.hose_id,
                h.hose_number,
                h.hose_code,
                pd.id as product_id,
                pd.name as product_name,
                pd.product_code,
                pd.color,
                pg.price,
                pg.programming_type,
                pg.programming_value,
                pg.programming_money,
                pg.programming_status_id,
                tps.status,
                tps.description,
                pg.balance,
                pg.system_id,
                sys.system_name,
                pg.source_id,
                pg.booking,
                pg.uuid,
                TO_CHAR(pg.registration_date,'YYYY-MM-DD HH24:MI:SS') as registration_date
                FROM public.programming as pg
                INNER JOIN public.station as s
                ON pg.station_id = s.id
                INNER JOIN public.hose as h
                ON pg.hose_id = h.id
                INNER JOIN public.product as pd
                ON h.product_id = pd.id
                INNER JOIN public.vehicle as v
                ON v.user_id = pg.user_id AND TRIM(v.plate) = TRIM(pg.identifier)
                INNER JOIN type.vehicle_model as vm
                ON v.vehicle_model_id = vm.id
                INNER JOIN type.vehicle_brand as vb
                ON vm.brand_id = vb.id
                INNER JOIN type.system as sys
                ON sys.id = pg.system_id
                INNER JOIN type.programming_status as tps
                ON tps.id = pg.programming_status_id
                WHERE pg.user_id =$1 AND pg.active = true AND pg.programming_status_id IN (2,3,6)
                ORDER BY pg.registration_date DESC LIMIT 5;`;
    const result = await pool.query(query,[id]);
    return result.rowCount>0 ? result.rows : [];
}