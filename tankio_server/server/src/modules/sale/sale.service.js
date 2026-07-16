const saleRepository = require('./sale.repository');
const bcrypt = require('bcrypt');
const { jwt_user,jwt_refresh_user} = require('../../helpers/jwt');



exports.registersaleinselect = async (data) => {
  return await saleRepository.registersaleinselect(data);
};

exports.getsalebyuser = async (id) => {
  return await saleRepository.getsalebyuser(id);
};

