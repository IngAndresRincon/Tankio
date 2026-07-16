const pool = require("../../database/pg");



exports.register = async (data) => {

  const existVehicle = await this.getVehicleByPlateAndUserId(data.userid,data.plate);
  if(existVehicle){
      const error = new Error('Vehicle already exists');
      error.statusCode = 409;
      error.code = '';
      throw error;
  }

  const vehicle = await createVehicle(data);

  if(!vehicle){
      const error = new Error('Vehicle could not be created');
      error.statusCode = 500;
      error.code = '';
      throw error;
  }

  return vehicle;
};


exports.getVehicleByPlateAndUserId = async (id,plate,)=>{
  const query = `SELECT * FROM public.vehicle WHERE user_id = $1 AND TRIM(plate) = TRIM($2)  AND active = true LIMIT 1;`;
  const result = await pool.query(query,[id,plate]);
  return result.rows[0] || null;
}


exports.getvehicletype = async ()=>{
  const query = `SELECT * FROM type.vehicle_type WHERE active = true;`;
  const result = await pool.query(query);
  return result.rowCount>0? result.rows :[];
}

exports.getbrandbyvehicletype = async (type)=>{
  const query = `SELECT * FROM type.vehicle_brand WHERE active = true AND vehicle_type_id = $1;`;
  const result = await pool.query(query,[type]);
  return result.rowCount>0? result.rows :[];
}

exports.getmodelbyvehiclebrand = async (brand)=>{
  const query = `SELECT * FROM type.vehicle_model WHERE active = true AND brand_id = $1;`;
  const result = await pool.query(query,[brand]);
  return result.rowCount>0? result.rows :[];
}

exports.getvehicleconnector = async ()=>{
  const query = `SELECT id,CONCAT(power_type,'-',connector_name) as connector,usage_note FROM type.vehicle_connector WHERE active = true;`;
  const result = await pool.query(query);
  return result.rowCount>0? result.rows :[];
}



exports.getVehiclesByUserId = async (userid) => {
  const query = `
    	SELECT 
      v.id,
      v.user_id,
      v.plate,
      v.uuid,
      COALESCE(vc.connector_name,'Fuel') as connector,
      vt.type,
      vb.brand,
      vm.model,
      CASE WHEN vc.id IS NULL THEN 'Gasoline' ELSE 'Electric' END Description,
      v.active,
      v.enable
        FROM public.vehicle as v
        LEFT JOIN type.vehicle_connector as vc
      ON v.vehicle_connector_id = vc.id
      INNER JOIN type.vehicle_model as vm
      ON v.vehicle_model_id = vm.id
      INNER JOIN type.vehicle_brand as vb
      ON vm.brand_id = vb.id
      INNER JOIN type.vehicle_type as vt
      ON vb.vehicle_type_id = vt.id
    WHERE v.user_id = $1 AND v.active = true`;
  const result = await pool.query(query, [userid]);
  return result.rowCount > 0 ? result.rows : [];
};
exports.editvehicle = async (id,data) => {
  const query = `UPDATE public.vehicle SET plate = $1, enable = $2
                WHERE id = $3 RETURNING *`;
  const result = await pool.query(query, [data.plate,data.enable,id]);
  return result.rowCount > 0 ? result.rows : [];
};

exports.deletevehicle = async (id) => {
  const query = `UPDATE public.vehicle SET active = $1
                WHERE id = $2 RETURNING *`;
  const result = await pool.query(query, [false,id]);
  return result.rowCount > 0 ? result.rows : [];
};




async function createVehicle(data){

  const query = `INSERT INTO public.vehicle (user_id,plate,vehicle_model_id,vehicle_connector_id)
                  VALUES($1,$2,$3,$4) RETURNING *;`;
  const result = await pool.query(query,[data.userid,data.plate,data.modelid,data.connectorid]);

  return result.rowCount>0 ? result.rows[0] : null;
}
