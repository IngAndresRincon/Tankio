const balanceRepository = require('./balance.repository');
const bcrypt = require('bcrypt');
const { jwt_controller} = require('../../helpers/jwt');


exports.getbalancemovementsbyuser = async (id) =>{
  return await balanceRepository.getbalancemovementsbyuser(id);
}

exports.getbalancegroupbyuser = async (id) =>{
  return await balanceRepository.getbalancegroupbyuser(id);
}

exports.getbalancebyid = async (id) =>{
  return await balanceRepository.getbalancebyid(id);
}
