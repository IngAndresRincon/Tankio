const stationRepository = require('./station.repository');
const bcrypt = require('bcrypt');
const { jwt_user,jwt_refresh_user} = require('../../helpers/jwt');



exports.dispenserpositionbycode = async (data) => {
  return await stationRepository.dispenserpositionbycode(data);
};

exports.dispenserpaymentgatewaybycode = async (code) => {
  return await stationRepository.dispenserpaymentgatewaybycode(code);
};


exports.getstationlocations = async (data) => {
  return await stationRepository.getstationlocations(data);
};

exports.getpaymentgatewayfromstation = async (data) => {
  return await stationRepository.getpaymentgatewayfromstation(data);
};


