const userRepository = require("./user.repository");
const { env } = require("../../config/env");


exports.authentication = async (data) => {
  const user = await userRepository.getUserByEmail(data.email);
  if (!user) {
    const error = new Error("user does not exist");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }

  const groups = await userRepository.getGroupsByUser(user.id);

  return {user,groups};

};

exports.getlistuser = async (id) => {
  const users = await userRepository.getlistuser(id);
  if (users.length === 0) {
    const error = new Error("user does not exist");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }
  return users;

};


exports.createuser = async (payload)=>{

  const isValidEmail = await userRepository.findEmailUserActive(payload.email);
  if(isValidEmail){
    const error = new Error("email already exist");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }

  return await  userRepository.createuser(payload);
}


exports.edituser = async (id, payload)=>{

  const isValidEmail = await userRepository.findEmailAnotherUser(id,payload.email);
  if(isValidEmail){
    const error = new Error("email already exist");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }

  return await  userRepository.edituser(id,payload);
}

exports.getuserstankioapp = async ()=>{
  return await userRepository.getuserstankioapp();
}



