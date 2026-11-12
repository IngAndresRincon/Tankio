const clientRepository = require("./client.repository");
const axios = require("axios");
const { env } = require("../../config/env");
const { randomInt } = require("node:crypto");

exports.validateIdentifier = async (identifier) => {

  let resultClient = null;

  //Validar primero si el cliente ingreso un Documento valido
  const acquirer = await validateAcquirer({ num: identifier });

  if(!acquirer || !acquirer.data.NumIdAdquiriente){
    let resultClient = await clientRepository.findClientByIdentifier(identifier);
    if(!client){
      resultClient = await clientRepository.registerDefaultClient(identifier);
    }
    return resultClient;
  }

    let client = await clientRepository.findClientByIdentifier(identifier);
    if (!client) {
      //registrar usuario
      acquirer.data.NumIdAdquiriente = identifier;
      client = await clientRepository.registerNewClientDIAN(acquirer.data);
    } else {
      if(acquirer.data.NumIdAdquiriente){
        client = await clientRepository.updateCustomerDetails(client.id,acquirer.data);
      }
      //actualizar información del usuario
    }
    resultClient = client;

  // if (acquirer.data.NumIdAdquiriente ) {
  //   let client = await clientRepository.findClientByIdentifier(identifier);
  //   if (!client) {
  //     //registrar usuario
  //     client = await clientRepository.registerNewClientDIAN(acquirer.data);
  //   } else {
  //     client = await clientRepository.updateCustomerDetails(client.id,acquirer.data);
  //     //actualizar información del usuario
  //   }
  //   resultClient = client;

  // } else {
  //   //crear usuario default con el número de documento
  //   resultClient = await clientRepository.registerDefaultClient(identifier);
  // }

  await clientRepository.recordClientValidation(resultClient.id);

  return resultClient;
};


exports.withoutValidation = async (identifier) => {

  let resultClient = null;

  //Validar primero si el cliente ingreso un Documento valido
  let dynamicCode = generateDinamicCode();
  let client = await clientRepository.findDinamicCode(dynamicCode);

  while(client){
    dynamicCode = generateDinamicCode();
    client = await clientRepository.findDinamicCode(dynamicCode);
  }
  resultClient = await clientRepository.registerDefaultClient(dynamicCode);

  return resultClient;
};


function generateDinamicCode(){
  return randomInt(0, 1_000_000).toString().padStart(6, "0");
};




async function validateAcquirer({ num }) {
  let result = null;

  try {
    const url = `${env.fe.url_adquirente}${num}`;

    const request = {
      method: "get",
      maxBodyLength: Infinity,
      timeout: 20000,
      url: url,
      headers: {
        "Content-Type": "application/json",
      },
      validateStatus: function (status) {
        return true;
      },
    };

    result = await axios
      .request(request)
      .then((response) => {
        return response;
      })
      .catch((error) => {
        console.error(error.message);
      });
  } catch (e) {
    console.error(e.message);
  }

  return result;
}
