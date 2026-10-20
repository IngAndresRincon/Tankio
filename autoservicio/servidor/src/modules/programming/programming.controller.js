const programmingService = require('./programming.service');



exports.createprogramming = async (req, res, next) => {
  try {
    const data = req.body;

    const result = await programmingService.createProgramming(data);

    return res.status(200).json({
      message: 'Programación procesada correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};



exports.findpendingprogramming = async (req, res, next) => {
  try {
    const {userId,screenId} = req.params;
    const result = await programmingService.findPendingProgrammingByUserId(parseInt(userId), parseInt(screenId));    
    if (!result.prepaidprogramming) {
      return res.status(204).end();
    }

    return res.status(200).json({
      message: 'Programación pendiente obtenida correctamente',
      data: result.prepaidprogramming,
    });
  } catch (error) {
    console.error(error.message);
    return next(error);
  }
}



exports.authorizeprogramming = async (req, res, next) => {
  try {
    const {programmingId} = req.params;
    const result = await programmingService.authorizeprogramming(parseInt(programmingId));

    return res.status(!result?404:200).json({
      message: 'Programación autorizada correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
}



exports.createpayment = async (req, res, next) => {
  try {
    const data = req.body;
    const result = await programmingService.createpayment(data);

    return res.status(200).json({
      message: 'Pago procesado correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};


exports.cancelpayment = async (req, res, next) => {
  try {
    const {transactionId} = req.params;

    const id = parseInt(transactionId);

    const result = await programmingService.cancelpayment(id);

    return res.status(200).json({
      message: 'Pago cancelado correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.lastsale = async (req, res, next) => {
  try {
    const {screenId} = req.params;

    const id = parseInt(screenId);
    const result = await programmingService.lastSaleByTerminalId(id);

    if (!result) {
      return res.status(204).end();
    }

    return res.status(200).json({
      message: 'Última venta obtenida correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};
exports.lastsalebyprogramming = async (req, res, next) => {
  try {
    const {programmindId} = req.params;

    const id = parseInt(programmindId);
    const result = await programmingService.lastsalebyprogramming(id);

    if (!result) {
      return res.status(204).end();
    }

    return res.status(200).json({
      message: 'Última venta obtenida correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.availableproducts = async (req, res, next) => {
  try {
    const {productId} = req.params;

    const id = parseInt(productId);
    const result = await programmingService.availableproducts(id);

    return res.status(200).json({
      message: 'Producto obtenidos',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};


exports.changeproduct = async (req, res, next) => {
  try {
    const {productId,programmingId} = req.params;

    const _productId = parseInt(productId);
    const _programmingId = parseInt(programmingId);

    const result = await programmingService.changeproduct(
      _productId,
      _programmingId
    );

    return res.status(!result?404:200).json({
      message: 'Programación autorizada correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
}
