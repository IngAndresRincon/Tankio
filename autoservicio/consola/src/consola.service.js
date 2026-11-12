const repository = require("./consola.repository");
const axios = require("axios");
const { env } = require("../config/env");

exports.findAuthorizedProgramming = async () => {
  return await repository.findAuthorizedProgramming();
};


exports.createPresetAuthorization = async ({programming}) =>{

  try {
      const requestAuth = await repository.findPresetAuthorizarionById(programming.id);
      if(requestAuth){
        console.error(
          `Ya existe una autorización activa para la programación: 
          ${JSON.stringify(programming)}`);
        return false;
      }

      const resultAuth = await repository.createPresetAuthorization({programming:programming});
      if(!resultAuth){
        console.error(`No se logró crear la autorización para: ${JSON.stringify(programming)}`);
        return false;
      }

      const resultProgramming =  await repository.synchronizeProgramming(resultAuth.id);
      return {resultProgramming};
  } catch (error) {
      console.log(error.message);
  }
  return null;
}