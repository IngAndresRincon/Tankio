const programmingRepository = require('./programming.repository');
const bcrypt = require('bcrypt');
const { jwt_user,jwt_refresh_user} = require('../../helpers/jwt');



exports.createprogramming = async (data) => {
  return await programmingRepository.createprogramming(data);
};

exports.getprogrammingbyuser = async (id) => {
  return await programmingRepository.getprogrammingbyuser(id);
};

exports.changestatusprogramming = async (uuid,status) => {

  const existProgramming = await programmingRepository.findProgramminguuid(uuid);
  if(!existProgramming){
      const error = new Error('UUID programming not found');
      error.statusCode = 401;
      error.code = '';
      throw error;
  }

  return await programmingRepository.changestatusprogramming(uuid,status);
};

exports.getactivitybyuser = async (id) => {
  return await programmingRepository.getactivitybyuser(id);
};

