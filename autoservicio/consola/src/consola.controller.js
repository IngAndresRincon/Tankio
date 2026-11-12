const service = require("./consola.service");


exports.synchronizeProgramming = async () =>{

  while(true){
    const records = await service.findAuthorizedProgramming();
    if(records){
      await service.createPresetAuthorization({programming:records});
    }
    await new Promise((resolve) => setTimeout(resolve, 2000)); // Esperar 10 segundos
  }

}
