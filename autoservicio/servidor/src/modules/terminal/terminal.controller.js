const terminalService = require('./terminal.service');


exports.synchronizeterminal = async (req, res, next) => {
  try {
    
    const body = req.body;

    const result = await terminalService.synchronizeterminal(body);
  
    return res.status(200).json({
      message: 'Productos obtenidos correctamente',
      data: result,
    });

  } catch (error) {
    return next(error);
  }
};




exports.authentication = async (req, res, next) => {
  try {
    const data = req.body;
    const result = await terminalService.authentication(data);

    return res.status(200).json({
      message: 'Autenticación de pantalla exitosa',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

