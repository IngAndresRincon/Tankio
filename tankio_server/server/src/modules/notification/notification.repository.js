const pool = require("../../database/pg");
const { createHttpError } = require("../../common/http-error");

exports.notificationsbyuser = async (id) => {

  const query = `SELECT 
                  id,
                  user_id,
                  station_id,
                  title,
                  description,
                  type,
                  notification_time,
                  synchronized,
                  active,
                  TO_CHAR(registration_date,'YYYY-MM-DD HH24:MI:SS') as registration_date
                  FROM public.notification 
                  WHERE active = true AND user_id = $1 ORDER BY registration_date DESC LIMIT 20;`;
  const values = [id];
  const result = await pool.query(query, values);
  return result.rowCount>0? result.rows : [];
}
