
const axios = require("axios");
const {env} = require('../../config/env');
const {desencrypter} = require('../../utils/encrypter');

// http://sms.insepet.com/sendsms?username=smsuser&password=KRzcicWsmMG3Lq&phonenumber=3208524893&message='Código de ingreso a tu portal autoservicio W9U5aHvO'



async function SMSService(param) {
  let response = undefined;

  const endpoint = `${env.sms.sms_endpoint}username=${desencrypter(env.sms.sms_user)}&password=${desencrypter(env.sms.sms_password)}&phonenumber=${param.phonenumber}&message=${param.message}`;

  try {
    const request = {
      method: "get",
      maxBodyLength: Infinity,
      timeout: 20000,
      url: endpoint,
      headers: {
        "Content-Type": "application/json",
      },
      validateStatus: function (status) {
        return true;
      },
    };

    response = await axios
      .request(request)
      .then((response) => {
        return response;
      })
      .catch((error) => {
        console.error(error.message);
      });
  } catch (error) {
    console.error(error);
  }
  return response;
}


module.exports = {SMSService };
