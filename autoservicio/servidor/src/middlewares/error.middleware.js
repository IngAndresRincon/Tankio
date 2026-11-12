function notFoundHandler(req, res) {
  res.locals.logError = {
    code: 'ROUTE_NOT_FOUND',
    message: 'Ruta no encontrada'
  };

  res.status(404).json({
    message: 'Ruta no encontrada',
    code: 'ROUTE_NOT_FOUND'
  });
}

function errorHandler(err, req, res, next) {
  void next;

  const statusCode = err.statusCode || 500;
  const payload = {
    message: err.message || 'Error interno del servidor'
  };

  if (err.code) {
    payload.code = err.code;
  }

  if (err.details) {
    payload.details = err.details;
  }

  res.locals.logError = {
    code: payload.code,
    message: payload.message
  };

  res.status(statusCode).json(payload);
}

module.exports = {
  notFoundHandler,
  errorHandler
};
