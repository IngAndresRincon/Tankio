const pool = require("../database/pg");
const { createHttpError } = require("../../common/http-error");

exports.historypaymentrequest = async (email)=>{
  const query = `SELECT 
                  pr.id as payment_request_id,
                  g.name as group_name,
                  s.name as station_name,
                  CONCAT(u.name,' ',u.last_name) as user_name,
                  pg.name as payment_gateway,
                  request_reference as payment_reference,
                  pr.invoice,
                  pr.amount,
                  pr.currency,
                  tprs.status as payment_status,
                  pr.gateway_response_payload,
                  pr.uuid,
                  pr.received_at,
                  pr.updated_at
                  FROM  public.payment_request as pr
                  INNER JOIN public.group as g
                  ON pr.group_id = g.id
                  INNER JOIN public.station as s
                  ON pr.station_id = s.id
                  INNER JOIN public.user as u
                  ON pr.user_id = u.id
                  INNER JOIN public.payment_gateway as pg
                  ON pr.payment_gateway_id = pg.id
                  INNER JOIN type.payment_request_status as tprs
                  ON pr.request_status_id = tprs.id
                  ORDER BY pr.id DESC LIMIT 10`;
  const result = await pool.query(query);
  return result.rowCount>0 ? result.rows: [];
}
