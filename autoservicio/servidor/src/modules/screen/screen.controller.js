const screenService = require('./screen.service');



exports.authentication = async (req, res, next) => {
  try {
    const data = req.body;

    const result = await screenService.authentication(data);

    return res.status(200).json({
      message: 'Autenticación de pantalla exitosa',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};
