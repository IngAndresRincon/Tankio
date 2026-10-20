const screenRepository = require('./screen.repository');
const {jwtscreen} = require('../../helpers/jwt');

exports.authentication = async (data) => {
  const screen = await screenRepository.findScreen(data);
  if(!screen){
    const error = new Error('No existe la terminal pantalla');
    error.statusCode = 404;
    error.code = 'STATION_NOT_FOUND';
    throw error;
  }  
  const payloadToken = {
    id: screen.id,
    rol: "screen",
    identifier: screen.serial,
  };

  
  const config = await screenRepository.findScreenConfiguration(screen);
  
  await screenRepository.updateScreenConfiguration(screen,data.ip);
  const token = jwtscreen(payloadToken);

  await screenRepository.screenLogin(screen.id,token);

  return {authentication:{screen,token},configuration:(config?.configuracion??[])};
};
