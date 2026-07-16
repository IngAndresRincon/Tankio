const userRepository = require("./group.repository");
const { env } = require("../../config/env");


exports.getlistgroup = async () => {
  return await userRepository.getlistgroup();
;

};
