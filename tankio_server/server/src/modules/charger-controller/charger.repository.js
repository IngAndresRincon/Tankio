const pool = require("../../database/pg");
const { createHttpError } = require("../../common/http-error");

exports.findControllerCharger = async (params) => {

   const query = `SELECT 
                  c.id as controller_id,
                  c.serial_identifier,
                  c.controller_type_id,
                  c.uuid as controller_uuid,
                  --d.id as dispenser_id,
                  --d.dispenser_type_id,
                  --d.positions,
                  --d.hoses,
                  --d.uuid as dispenser_uuid,
                  s.id as station_id,
                  s.name,
                  s.group_id,
                  s.uuid as station_uuid
                  FROM public.controller as c 
                  INNER JOIN public.controller_dispenser as cd
                  ON c.id = cd.controller_id AND cd.active = true
                  INNER JOIN public.dispenser as d
                  ON d.id = cd.dispenser_id AND cd.active = true
                  INNER JOIN public.station as s
                  ON s.id = d.station_id
                  WHERE c.uuid = $1 AND s.uuid = $2 LIMIT 1;`;
  const values = [params.controller_uuid, params.station_uuid];
  const result = await pool.query(query, values);
  return result.rows[0] || null;
}


exports.findDispenserByControllerId = async (controllerid) => {

   const query = `SELECT
                  d.id AS dispenser_id,
                  d.dispenser_type_id,
                  dt.type,
                  d.positions,
                  d.hoses,
                  d.uuid AS dispenser_uuid,
                  pos.id AS position_id,
                  pos.status,
                  pos.position_number,
                  pos.position_code,
                  COALESCE(
                    JSON_AGG(
                      JSON_BUILD_OBJECT(
                        'hose_id', h.id,
                        'hose_number', h.hose_number,
                        'hose_code', h.hose_code,
                        'product_id', pr.id,
                        'product_name', pr.name,
                        'product_code', pr.product_code
                      )
                      ORDER BY h.hose_number
                    ) FILTER (WHERE h.id IS NOT NULL),
                    '[]'::json
                  ) AS hoses
                FROM controller_dispenser AS cd
                INNER JOIN public.dispenser AS d
                  ON cd.dispenser_id = d.id
                INNER JOIN public.position AS pos
                  ON pos.dispenser_id = d.id
                LEFT JOIN public.hose AS h
                  ON h.position_id = pos.id
                LEFT JOIN public.product AS pr
                  ON pr.id = h.product_id
                INNER JOIN type.dispenser AS dt
                  ON dt.id = d.dispenser_type_id
                WHERE cd.controller_id = $1
                  AND cd.active = true
                GROUP BY
                  d.id,
                  d.dispenser_type_id,
                  dt.type,
                  d.positions,
                  d.hoses,
                  d.uuid,
                  pos.id,
                  pos.status,
                  pos.position_number,
                  pos.position_code
                ORDER BY pos.position_number;`;
  const values = [controllerid];
  const result = await pool.query(query, values);
  return result.rowCount>0? result.rows : [];
}


exports.findProgrammingIdByPosition = async ({id}) =>{
  const query = `SELECT id FROM public.programming 
  WHERE position_id = $1 AND programming_status_id = $2 LIMIT 1; `;
  const result = await pool.query(query,[id,3]);
  return result.rowCount>0?result.rows[0].id : null;
}


exports.telemetry = async ({id,params,programmingId}) =>{
  
  const query = `INSERT INTO public.telemetry (
                  position_id,
                  hose_in_use,
                  status,
                  current,
                  voltage,
                  power,
                  programming_id
                  )
                VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *;`;
  const result = await pool.query(query,[
    id,
    params.hose_in_use,
    params.status,
    params.current,
    params.voltage,
    params.power,
    programmingId
  ]);

  return result.rowCount>0? true:false;
}

exports.updatestatusconnector = async (id,params) => {
  const query = `UPDATE public.position 
  SET current=$1, 
  voltage = $2,
  power = $3, 
  percentage = $4, 
  hose_in_use = $5,
  status = $6,
  updated_at = now()
  WHERE id = $7 RETURNING *;`;
  const values = [params.current, params.voltage,
  params.power,params.percentage,params.hose_in_use,params.status,id];
  const result = await pool.query(query, values);
  return result.rowCount>0? result.rows[0] : null;
}

