const pool = require("../../database/pg");
const { createHttpError } = require("../../common/http-error");

exports.getbalancemovementsbyuser = async (id) => {
  const query = `    
            SELECT 
            bm.id as balance_movement_id,
            bm.group_id,
            bm.station_id,
            bm.user_id,
            bm.amount,
            bm.balance_movement_type_id,
            bmt.movement,
            bm.synchronized,
            bm.uuid as balance_movement_uui,
            g.id as group_id,
            g.name as group_name,
            g.company_name,
            s.id as station_id,
            s.name as station_name,
            s.address,
            TO_CHAR(bm.registration_date,'YYYY-MM-DD HH24:MI:SS') as registration_date
            FROM public.balance_movement as bm
            INNER JOIN type.balance_movement as bmt
            ON bm.balance_movement_type_id = bmt.id
            INNER JOIN public.group as g
            ON bm.group_id = g.id
            INNER JOIN public.station as s
            ON bm.station_id = s.id
            WHERE bm.user_id = $1 AND synchronized = true 
            ORDER BY bm.id desc;`;
  const values = [id];
  const result = await pool.query(query, values);
  return result.rowCount > 0 ? result.rows : [];
};



exports.getbalancegroupbyuser = async (id) => {
  const query = `    
           SELECT 
            b.id as balance_id,
            b.user_id,
            b.balance_amount as balance,
            b.uuid as balance_uuid,
            TO_CHAR(b.last_move_date,'YYYY-MM-DD HH24:MI:SS') as last_move_date,
            g.id as group_id,
            g.name as group_name,
            g.company_name,
            g.address,
            g.prefix_code
            FROM  public.balance as b
            INNER JOIN public.group as g
            ON b.group_id = g.id 
            INNER JOIN public.user as u
            ON b.user_id = u.id
            AND b.user_id = $1 AND u.active = true AND b.active = true;`;
  const values = [id];
  const result = await pool.query(query, values);
  return result.rowCount > 0 ? result.rows : [];
};



exports.getbalancebyid = async (id) => {
  const query = `    
           SELECT 
            b.id as balance_id,
            b.user_id,
            ROUND(b.balance_amount) as balance,
            b.uuid as balance_uuid,
            TO_CHAR(b.last_move_date,'YYYY-MM-DD HH24:MI:SS') as last_move_date,
            g.id as group_id,
            g.name as group_name,
            g.company_name,
            g.address,
            g.prefix_code
            FROM  public.balance as b
            INNER JOIN public.group as g
            ON b.group_id = g.id 
            INNER JOIN public.user as u
            ON b.user_id = u.id
            WHERE b.id =$1 AND u.active = true AND b.active = true LIMIT 1;`;
  const values = [id];
  const result = await pool.query(query, values);
  return result.rowCount > 0 ? result.rows[0] : null;
};

