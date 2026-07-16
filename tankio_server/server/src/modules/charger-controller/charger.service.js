const chargerRepository = require('./charger.repository');
const bcrypt = require('bcrypt');
const { jwt_controller} = require('../../helpers/jwt');


exports.findControllerCharger = async (params) =>{
  const charger = await  chargerRepository.findControllerCharger(params);

  if(!charger){
      const error = new Error('Invalid controller credentials');
      error.statusCode = 401;
      error.code = '';
      throw error;
  }

  const dispenser = await chargerRepository.findDispenserByControllerId(charger.controller_id)

  const jwtmodel = {
      id :charger.controller_id,
      rol:'controller',
      identifier:charger.controller_uuid
  }
  const token = jwt_controller(jwtmodel);

  return {charger:{controller:charger,dispenser:dispenser},token:token};
  
}



exports.updatestatus = async (id,params) =>{
  return chargerRepository.updatestatus(id,params);
  
}
