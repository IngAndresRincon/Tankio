const pool = require("../database/pg");
const { createHttpError } = require("../../common/http-error");



exports.getbalancebyuser = async ()=>{
  const query = `
 SELECT
      u.*,
	  d.type as document_type,
      jsonb_build_object(
        'balance',
        COALESCE(
          sb.balance,
          '[]'::jsonb
        )
      ) AS balance
    FROM public.user AS u
	INNER JOIN type.document as d
	ON d.id = u.document_type_id
    LEFT JOIN LATERAL (
      SELECT jsonb_agg(
        jsonb_build_object(
          'balance_id', b.id,
          'balance', ROUND(b.balance_amount),
          'balance_uuid', b.uuid,
          'last_move_date', TO_CHAR(b.last_move_date, 'YYYY-MM-DD HH24:MI:SS'),
          'group', jsonb_build_object(
            'group_id', g.id,
            'group_name', g.name,
            'company_name', g.company_name,
            'address', g.address,
            'prefix_code', g.prefix_code
          )
        )
        ORDER BY b.id
      ) AS balance
      FROM public.balance AS b
      INNER JOIN public.group AS g
        ON g.id = b.group_id	 
      WHERE b.user_id = u.id AND b.active = true) AS sb ON true
    ORDER BY u.id DESC;`;
  const result = await pool.query(query);
  return result.rowCount>0 ? result.rows: [];
}
