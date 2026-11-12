const jwt = require('jsonwebtoken');
const { env } = require('../config/env');
const screenRepository = require('../modules/screen/screen.repository');

function getBearerToken(req) {
  const authorization = req.get('authorization');

  if (!authorization || !authorization.startsWith('Bearer ')) {
    return null;
  }

  const token = authorization.slice('Bearer '.length).trim();
  return token || null;
}

async function validateToken(req, res, next) {
  const token = getBearerToken(req);

  if (!token) {
    const error = new Error('Debe enviar el JWT en el header Authorization con el esquema Bearer');
    error.statusCode = 401;
    error.code = 'MISSING_BEARER_TOKEN';
    return next(error);
  }

  try {
    // jwt.verify comprueba firma y las fechas exp/nbf incluidas en el token.
    const payload = jwt.verify(token, env.jwtsecret, { algorithms: ['HS256'] });

    if (payload.role !== 'screen' || !payload.sub || !payload.identifier) {
      const error = new Error('El token no tiene autorización para operar como estación');
      error.statusCode = 403;
      error.code = 'INVALID_SCREEN_ROLE';
      return next(error);
    }

    // La comprobación en BD permite revocar el acceso al desactivar la estación,
    // aun cuando el JWT todavía no haya vencido.
    const screen = await screenRepository.findActiveScreen({
      id: payload.sub,
      identifier: payload.identifier
    });

    if (!screen) {
      const error = new Error('La estación está inactiva o ya no existe');
      error.statusCode = 403;
      error.code = 'STATION_NOT_AUTHORIZED';
      return next(error);
    }

    // Disponible para controladores o servicios que necesiten saber quién hizo la petición.
    req.station = {
      id: screen.id,
      identifier: screen.serial
    };
    req.auth = payload;

    return next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
      const code = error.name === 'TokenExpiredError' ? 'TOKEN_EXPIRED' : 'INVALID_TOKEN';
      const message = error.name === 'TokenExpiredError'
        ? 'El JWT ha expirado'
        : 'El JWT no es válido';
      const jwtError = new Error(message);
      jwtError.statusCode = 401;
      jwtError.code = code;
      return next(jwtError);
    }

    return next(error);
  }
}

module.exports = {validateToken};
