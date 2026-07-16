const notificationRepository = require('./notification.repository');
const bcrypt = require('bcrypt');
const { jwt_controller} = require('../../helpers/jwt');


exports.notificationsbyuser = async (id) =>{
  return await notificationRepository.notificationsbyuser(id);
}
