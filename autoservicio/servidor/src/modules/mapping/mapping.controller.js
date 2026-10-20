const mappingService = require('./mapping.service');



exports.mapping = async (req, res, next) => {
  try {
    const {serial} = req.params;
    const result = await mappingService.mapping(req,serial);

    return res.status(200).json({
      message: 'Configuración de pantalla obtenida correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};
