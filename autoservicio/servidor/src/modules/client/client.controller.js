const clientService = require('./client.service');


exports.validateIdentifier = async (req, res, next) => {
  try {
    const {identifier} = req.params;

    const result = await clientService.validateIdentifier(identifier);

    return res.status(200).json({
      message: 'Cliente validado correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.withoutValidation = async (req, res, next) => {
  try {
    
    const result = await clientService.withoutValidation();

    return res.status(201).json({
      message: 'Cliente sin validación creado correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};



