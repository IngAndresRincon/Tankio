const pool = require("../../database/pg");
const { createHttpError } = require("../../common/http-error");


exports.dispenserpositionbycode = async (code) => {

  const positions = await getDispenserPositionsByCode(code);
  if(!positions){
      const error = new Error('Dispenser positions not found');
      error.statusCode = 404;
      error.code = '';
      throw error;
  }
  return positions;
};



exports.dispenserpaymentgatewaybycode = async (code) => {

   const query = `
                SELECT 
                g.id as group_id,
                g.name as group_name,
                g.company_name,
                g.web_page,
                s.id as station_id,
                s.name as station_name,               
                s.station_type_id,               
                s.active,
                s.uuid,
                pgw.payment_gateways,
				        pos.position_code
                FROM public.group as g 
                INNER JOIN public.station as s
                ON s.group_id = g.id
                INNER JOIN type.station as ts
                ON ts.id = s.station_type_id
                INNER JOIN public.dispenser as d
                ON d.station_id = s.id
                INNER JOIN public.position as pos
                ON pos.dispenser_id = d.id
                LEFT JOIN LATERAL (
                  SELECT COALESCE(
                    jsonb_agg(
                      jsonb_build_object(
                        'id', pg.id,
                        'code', pg.code,
                        'name', pg.name,
                        'enabled', gpg.enabled,
                        'is_default', gpg.is_default,
                        'environment', gpg.environment,
                        'test',gpg.test,
                        'credentials',gpg.credentials,
                        'settings',gpg.settings,
                        'transaction_fee',gpg.transaction_fee
                      )
                      ORDER BY pg.id
                    ) FILTER (WHERE pg.id IS NOT NULL),
                    '[]'::jsonb
                  ) AS payment_gateways
                  FROM public.group_payment_gateway gpg
                  INNER JOIN public.payment_gateway pg
                  ON pg.id = gpg.payment_gateway_id
                  WHERE gpg.group_id = g.id
                    AND gpg.enabled = true
                    AND pg.active = true
                ) pgw ON true
                WHERE s.active = true AND pos.position_code = $1 LIMIT 1;`;
  const result = await pool.query(query, [code]);
  return result.rowCount>0? result.rows : [];
};

exports.getstationlocations = async (code) => {

  const query = `
                 SELECT 
                g.id as group_id,
                g.name as group_name,
                g.company_name,
                g.web_page,
                pgw.payment_gateways,
                s.id as station_id,
                s.name as station_name,
                s.latitude,
                s.longitude,
                s.station_type_id,
                ts.station_name as type_station_name,
                s.address,
                s.active,
                s.uuid
                FROM public.group as g 
                INNER JOIN public.station as s
                ON s.group_id = g.id
                INNER JOIN type.station as ts
                ON ts.id = s.station_type_id
                LEFT JOIN LATERAL (
                  SELECT COALESCE(
                    jsonb_agg(
                      jsonb_build_object(
                        'id', pg.id,
                        'code', pg.code,
                        'name', pg.name,
                        'enabled', gpg.enabled,
                        'is_default', gpg.is_default,
                        'environment', gpg.environment,
                        'test',gpg.test
                      )
                      ORDER BY pg.id
                    ) FILTER (WHERE pg.id IS NOT NULL),
                    '[]'::jsonb
                  ) AS payment_gateways
                  FROM public.group_payment_gateway gpg
                  INNER JOIN public.payment_gateway pg
                  ON pg.id = gpg.payment_gateway_id
                  WHERE gpg.group_id = g.id
                    AND gpg.enabled = true
                    AND pg.active = true
                ) pgw ON true
                WHERE s.active = true
                ORDER BY g.id ASC;`;
  const result = await pool.query(query);
  return result.rowCount>0? result.rows : [];
};


exports.getpaymentgatewayfromstation = async (code) => {

  const query = `
                SELECT 
                g.id as group_id,
                g.name as group_name,
                g.company_name,
                g.web_page,
                s.id as station_id,
                s.name as station_name,               
                s.station_type_id,               
                s.active,
                s.uuid,
                pgw.payment_gateways
                FROM public.group as g 
                INNER JOIN public.station as s
                ON s.group_id = g.id
                INNER JOIN type.station as ts
                ON ts.id = s.station_type_id
                LEFT JOIN LATERAL (
                  SELECT COALESCE(
                    jsonb_agg(
                      jsonb_build_object(
                        'id', pg.id,
                        'code', pg.code,
                        'name', pg.name,
                        'enabled', gpg.enabled,
                        'is_default', gpg.is_default,
                        'environment', gpg.environment,
                        'test',gpg.test,
                        'credentials',gpg.credentials,
                        'settings',gpg.settings,
                        'transaction_fee',gpg.transaction_fee
                      )
                      ORDER BY pg.id
                    ) FILTER (WHERE pg.id IS NOT NULL),
                    '[]'::jsonb
                  ) AS payment_gateways
                  FROM public.group_payment_gateway gpg
                  INNER JOIN public.payment_gateway pg
                  ON pg.id = gpg.payment_gateway_id
                  WHERE gpg.group_id = g.id
                    AND gpg.enabled = true
                    AND pg.active = true
                ) pgw ON true
                WHERE s.active = true
                ORDER BY g.id ASC;`;
  const result = await pool.query(query);
  return result.rowCount>0? result.rows : [];
};


async function getDispenserPositionsByCode(code){
  const query =`SELECT 
                  g.id as group_id,
                  g.name as group_name,
                  g.company_name,
                  g.web_page,
                  pgw.payment_gateways,
                  s.id as station_id,
                  s.name as station_name,
                  st.station_name as station_type,
                  s.latitude,
                  s.longitude,
                  s.address,
                  d.id as dispenser_id,
                  dt.id as dispenser_type_id,
                  dt.type as dispenser_type,
                  p.id as position_id,
                  cd.controller_id as controller_id,
                  p.status,
                  p.hose_in_use,
                  p.position_number,
                  p.position_code,
                  h.id as hose_id,
                  h.hose_number,
                  h.hose_code,
                  pd.id as product_id,
                  --pd.name as product,
				  CASE WHEN dt.id IN (1,2) THEN pd.name ELSE CONCAT(vc.connector_name,' - ',vc.power_type) END as product,
                  pd.product_code,
                  pd.color,
                  pr.id as price_id,
                  pr.price,
                  pr.currency,
                  pr.symbol
              FROM public.position as p
              INNER JOIN public.hose as h
              ON p.id = h.position_id
              INNER JOIN public.product as pd
              ON h.product_id = pd.id
              INNER JOIN public.price as pr
              ON pr.product_id = pd.id
              INNER JOIN public.dispenser as d
              ON d.id =p.dispenser_id
              INNER JOIN public.station as s
              ON s.id = d.station_id
              INNER JOIN public.group as g
              ON g.id = s.group_id
              INNER JOIN type.station st
              ON st.id = s.station_type_id
              INNER JOIN type.dispenser as dt
              ON dt.id = d.dispenser_type_id
			  INNER JOIN public.controller_dispenser as cd
			  ON cd.dispenser_id = d.id
              LEFT JOIN LATERAL (
                SELECT COALESCE(
                  jsonb_agg(
                    jsonb_build_object(
                      'id', pg.id,
                      'code', pg.code,
                      'name', pg.name,
                      'enabled', gpg.enabled,
                      'is_default', gpg.is_default,
                      'environment', gpg.environment,
                      'transaction_fee', gpg.transaction_fee
                    )
                    ORDER BY pg.id
                  ) FILTER (WHERE pg.id IS NOT NULL),
                  '[]'::jsonb
                ) AS payment_gateways
                FROM public.group_payment_gateway gpg
                INNER JOIN public.payment_gateway pg
                ON pg.id = gpg.payment_gateway_id
                WHERE gpg.group_id = g.id
                  AND gpg.enabled = true
                  AND pg.active = true
              ) pgw ON true
              LEFT OUTER JOIN public.vehicle_connector_hose as vch
              ON vch.hose_id = h.id
              LEFT OUTER JOIN type.vehicle_connector as vc
              ON vc.id = vch.vehicle_connector_id
              WHERE p.active = true AND h.active = true AND  position_code = $1`;
    const result = await pool.query(query,[code]);
    return result.rowCount>0? result.rows : [];
}
