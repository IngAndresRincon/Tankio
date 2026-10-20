const terminalRepository = require('./terminal.repository');
const {env} = require('../../config/env')
const {jwtterminal} = require('../../helpers/jwt');


exports.synchronizeterminal = async (payload) => {

  const terminal = await terminalRepository.findTerminalActive(payload.serial);
  if(!terminal){
    const error = new Error('La terminal no existe');
    error.statusCode = 404;
    error.code = 'TERMINAL_NOT_FOUND';
    throw error;
  }
  const terminalUpdated = await terminalRepository.updateTerminalData(terminal.id,payload);

  return terminalUpdated;
};



exports.authentication = async (payload) => {
  console.log(`Datos de la terminal: ${JSON.stringify(payload)}`);
  const terminal = await terminalRepository.findTerminalActive(payload.serial);
  if(!terminal){
    const error = new Error('No existe la terminal pantalla');
    error.statusCode = 404;
    error.code = 'STATION_NOT_FOUND';
    throw error;
  }  
  const payloadToken = {
    id: terminal.id,
    rol: "terminal",
    identifier: terminal.serial,
  };  
  const token = jwtterminal(payloadToken);
//  return {authentication:{terminal,token}};
  return {token};

};
