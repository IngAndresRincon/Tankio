const configurationService = require('./configuration.service');


exports.findproducts = async (req, res, next) => {
  try {
    
    const result = await configurationService.findproducts();
  
    return res.status(200).json({
      message: 'Productos obtenidos correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};


exports.updateproduct = async (req, res, next) => {
  try {
    
    const {productId} = req.params;
    const body = req.body;
    const result = await configurationService.updateproduct(parseInt(productId),body);
  
    return res.status(200).json({
      message: 'Producto actualizado correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};


exports.findpaymentmethods = async (req, res, next) => {
  try {

    const {screenId} = req.params;
    const result = await configurationService.findpaymentmethods(parseInt(screenId));
  
    return res.status(200).json({
      message: 'Métodos de pago obtenidos correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};

exports.updatepaymentmethod = async (req, res, next) => {
  try {

    const {paymentMethodId} = req.params;
    const body = req.body;
    const result = await configurationService.updatepaymentmethod(parseInt(paymentMethodId),body);
  
    return res.status(200).json({
      message: 'Método de pago actualizado correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};

exports.imagebanner = async (req, res, next) => {
  try {
    const result = await configurationService.imagebanner(req);
    return res.status(200).json({
      message: 'Imágenes de banner obtenidas correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};

exports.video = async (req, res, next) => {
  try {
    const result = await configurationService.videos(req);
    return res.status(200).json({
      message: 'Videos obtenidos correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};

exports.changevideo= async (req, res, next) => {
  try {

    const {screenId} = req.params;
    const body = req.body;

    const id = Number(screenId);
    if (!Number.isSafeInteger(id) || id <= 0) {
      return res.status(400).json({ message: 'El screenId no es valido.' });
    }
    if (id !== Number(req.station.id)) {
      return res.status(403).json({ message: 'La pantalla no corresponde al dispositivo autenticado.' });
    }
    const result = await configurationService.changevideo(id,body);
    return res.status(200).json({
      message: 'Video actualizado correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};

