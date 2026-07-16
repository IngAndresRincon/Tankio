const pool = require("../../database/pg");
const { createHttpError } = require("../../common/http-error");


exports.registersaleinselect = async (data) => {

  const existSale = await findSaleByUUID(data.programminguuid);
  if(existSale){
    console.log("Actualizar datos de venta");
    return existSale;
  }

  const newSale = await registerNewSale(data);

  return newSale;
};

async function findSaleByUUID(uuid){
  const query = `SELECT * FROM public.sale WHERE programming_uuid = $1 LIMIT 1;`;
  const result = await pool.query(query,[uuid]);
  return result.rows[0] || null;
}

async function registerNewSale(data){

  const money_sale = Math.round(((data.price * data.power) / 1000)); // 1000 son 1kwatts

  const query = `INSERT INTO public.sale (
  programming_uuid,
  position_id,
  hose_id,
  price,
  money,
  power,
  total_power,
  initial_date_sale,
  final_date_sale) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *;`;
  const result=await pool.query(query,[
    data.programminguuid,
    data.positionid,
    data.hoseid,
    data.price,
    money_sale,
    data.power,
    data.totalpower,
    data.startdate,
    data.enddate]);
  
  return result.rows[0] || null;
}



exports.getsalebyuser = async (id) => {

  const query = `SELECT 
                  s.id as sale_id,
                  sys.id as system_id,
                  sys.system_name,
                  tst.station_name,
                  s.position_id,
                  s.hose_id,
                  p.name as product_name,
                  s.price,
                  s.money,
                  s.volume,
                  s.power,
                  s.total_power,
                  TO_CHAR(s.initial_date_sale::timestamp,'YYYY-MM-DD HH24:MI:SS') as initial_date_sale,
                  TO_CHAR(s.final_date_sale::timestamp,'YYYY-MM-DD HH24:MI:SS') as final_date_sale,
                  s.zero_sale,
                  s.uuid as sale_uuid,
                  pg.id as programming_id,
                  g.id as group_id,
                  g.name as group_name,
                  g.company_name,
                  pg.station_id,
                  st.name as station_name,
                  st.address as station_address,
                  pg.identifier,
                  pg.user_id,
                  pg.controller_id,
                  pg.programming_type,
                  pg.programming_money,
                  pg.programming_status_id,
                  pg.balance,
                  pg.booking,
                  TO_CHAR(pg.registration_date,'YYYY-MM-DD HH24:MI:SS') as registration_date 
                  FROM  public.sale as s
                  INNER JOIN public.programming as pg
                  ON s.programming_uuid = pg.uuid
                  INNER JOIN public.station as st
                  ON pg.station_id = st.id
                  INNER JOIN public.group as g
                  ON st.group_id = g.id
                  INNER JOIN type.system as sys
                  ON pg.system_id = sys.id
                  INNER JOIN type.station as tst
                  ON st.station_type_id = tst.id
                  INNER JOIN public.hose as h 
                  ON pg.hose_id = h.id
                  INNER JOIN public.product as p
                  ON h.product_id = p.id
                  WHERE pg.user_id = $1 ORDER BY registration_date DESC;`;
  const result = await pool.query(query,[id]);
  return result.rowCount>0? result.rows : [];
  
};

