const mappingRepository = require('./mapping.repository');
const fs = require('fs/promises');
const path = require('path');
const {env} = require('../../config/env')
const imagesDir = path.resolve(__dirname, '../../../public/img');
const allowedExtensions = new Set(['.png', '.jpg', '.jpeg', '.gif']);


exports.mapping = async (req,serial) => {

  const screen = await mappingRepository.findScreenBySerial(serial);
  if(!screen){
    const error = new Error('No se existe el serial de la pantalla en el sistema');
    error.statusCode = 404;
    error.code = 'STATION_NOT_FOUND';
    throw error;
  }

  const hoses = await mappingRepository.findHosesByScreenId(screen.id);
  screen.hoses = hoses;


  const paymentMethods = await mappingRepository.findPaymentMethodsByPosition(screen.fk_id_posicion );
  screen.paymentMethods = paymentMethods;

  const speedDial = await mappingRepository.findSpeedDialOptionsByPosition(screen.fk_id_posicion );
  screen.speedDial = speedDial;

  const bannerList = await listBannerImage({req:req});
  screen.banner = bannerList;

  return {screen};
};



async function listBannerImage({req}) {

  let images = [];
  try {
    const entries = await fs.readdir(imagesDir, { withFileTypes: true });

     images = entries
      .filter((entry) => {
        const extension = path.extname(entry.name).toLowerCase();
        return entry.isFile() && allowedExtensions.has(extension);
      })
      .map((entry) => ({
        name: entry.name,
        url: `${req.protocol}://${env.urlServer}:${env.port}/public/image/${encodeURIComponent(entry.name)}`
      }));
  } catch (error) {
    throw error;
  }
  return images;
}


