const configurationRepository = require('./configuration.repository');
const fs = require('fs/promises');
const path = require('path');
const imagesDir = path.resolve(__dirname, '../../../public/img');
const videosDir = path.resolve(__dirname, '../../../public/video');
const allowedImageExtensions = new Set(['.png', '.jpg', '.jpeg', '.gif']);
const allowedVideoExtensions = new Set(['.mp4']);
const {env} = require('../../config/env')


exports.findproducts = async () => {
  const products = await configurationRepository.findproducts();
  return products;
};

exports.updateproduct = async (productId,payload) => {

  if(payload.precio.toString().length>5){
    const error = new Error('Formato de precio no valido');
    error.statusCode = 404;
    error.code = 'PRICE_NOT_VALID';
    throw error;
  }

  const products = await configurationRepository.updateproduct(productId,payload);
  if (!products) {
    const error = new Error('El producto no existe');
    error.statusCode = 404;
    error.code = 'PRODUCT_NOT_FOUND';
    throw error;
  }
  return products;
};

exports.findpaymentmethods = async(screenId) =>{
  return await configurationRepository.findpaymentmethods(screenId);
}


exports.updatepaymentmethod = async (paymentMethodId,payload)=>{
  const paymentMethod = await configurationRepository.updatepaymentmethod(paymentMethodId,payload);
  if (!paymentMethod) {
    const error = new Error('El método de pago no existe');
    error.statusCode = 404;
    error.code = 'PAYMENT_METHOD_NOT_FOUND';
    throw error;
  }
  return paymentMethod;
}

exports.imagebanner = async(req)=>{
  const bannerList = await listBannerImage({req:req});
  return bannerList;
}


async function listBannerImage({req}) {

  let images = [];
  try {
    const entries = await fs.readdir(imagesDir, { withFileTypes: true });

     images = entries
      .filter((entry) => {
        const extension = path.extname(entry.name).toLowerCase();
        return entry.isFile() && allowedImageExtensions.has(extension);
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


exports.videos = async(req)=>{
  const videoList = await listVideos({req:req});
  return videoList;
}

async function listVideos({req}) {

  let images = [];
  try {
    const entries = await fs.readdir(videosDir, { withFileTypes: true });

     images = entries
      .filter((entry) => {
        const extension = path.extname(entry.name).toLowerCase();
        return entry.isFile() && allowedVideoExtensions.has(extension);
      })
      .map((entry) => ({
        name: entry.name,
        url: `${req.protocol}://${env.urlServer}:${env.port}/public/video/${encodeURIComponent(entry.name)}`
      }));
  } catch (error) {
    throw error;
  }
  return images;
}


exports.changevideo = async(screenId,payload)=>{

  if (!payload?.name || typeof payload.name !== 'string') {
    const error = new Error('Debe enviar el nombre del video');
    error.statusCode = 400;
    error.code = 'INVALID_VIDEO_NAME';
    throw error;
  }

  const extension = path.extname(payload.name);
  if (payload.name !== path.basename(payload.name) || /[\\/\x00]/.test(payload.name) ||
      !allowedVideoExtensions.has(extension.toLowerCase())) {
    const error = new Error('El nombre del video no es valido');
    error.statusCode = 400;
    throw error;
  }
  let file;
  try {
    file = await fs.stat(path.join(videosDir, payload.name));
  } catch (error) {
    if (error.code === 'ENOENT') error.statusCode = 404;
    throw error;
  }
  if (!file.isFile()) {
    const error = new Error('El archivo de video no existe');
    error.statusCode = 404;
    throw error;
  }
  const videoName = path.basename(payload.name, extension);

  const result = await configurationRepository.changevideo(screenId,videoName,extension);
  if(!result){
      const error = new Error(`No se logró actualziar la información del video`);
      error.statusCode = 404;
      error.code = 'VIDEO_CONFIGURATION_NOT_FOUND';
      throw error;
  }

  return result;
}
