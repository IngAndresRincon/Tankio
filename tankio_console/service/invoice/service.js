
const axios = require("axios");
const {env} = require('../../config/env');

async function InvoiceService(method,endpoint,apikey,payload) {
  let response = undefined;
  const urlRequest = `${env.url_invoice}${endpoint}`;
  try {
    const request = {
      method: method,
      maxBodyLength: Infinity,
      timeout: 20000,
      url: urlRequest,
      headers: {
        "Content-Type": "application/json",
        "api-key":apikey
      },
      data:payload,      
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


async function GenerateInvoice(method,endpoint,config,payload){
  let response = undefined;
  const urlRequest = `${env.url_invoice}${endpoint}`;
  try {
    const request = {
      method: method,
      maxBodyLength: Infinity,
      timeout: 20000,
      url: urlRequest,
      headers: {
        "Content-Type": "application/json",
        "api-key":config.api_key,
        "x-station-id":config.station_id_invoice,
        "x-terminal-id": config.terminal_id_invoice,
        "Authorization": `Bearer ${config.token_authentication.access_token}`
      },
      data:payload,      
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


module.exports = {InvoiceService ,GenerateInvoice};
