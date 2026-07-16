const vehicleRepository = require('./vehicle.repository');

exports.register = async (data) => {
  return await vehicleRepository.register(data);
};
exports.getvehicletype = async () => {
  return await vehicleRepository.getvehicletype();
};
exports.getbrandbyvehicletype = async (type) => {
  return await vehicleRepository.getbrandbyvehicletype(type);
};
exports.getmodelbyvehiclebrand = async (brand) => {
  return await vehicleRepository.getmodelbyvehiclebrand(brand);
};

exports.getvehicleconnector = async () => {
  return await vehicleRepository.getvehicleconnector();
};
exports.editvehicle = async (id,body) => {
  return await vehicleRepository.editvehicle(id,body);
};
exports.deletevehicle = async (id,body) => {
  return await vehicleRepository.deletevehicle(id,body);
};

exports.getVehiclesByUserId = async (userid) => {
  if (!Number.isInteger(userid) || userid <= 0) {
    const error = new Error('userid is invalid');
    error.statusCode = 400;
    error.code = '';
    throw error;
  }

  return await vehicleRepository.getVehiclesByUserId(userid);
};
