const {env} = require('../config/env');

function getApiKeyFromRequest(req) {
  const headerKey = req.get('x-api-key');
  if (headerKey) return headerKey;

  const authHeader = req.get('authorization');
  if (authHeader && authHeader.toLowerCase().startsWith('bearer ')) {
    return authHeader.slice(7).trim();
  }

  return req.query.api_key || req.query.apiKey || '';
}

function validateApiKey(req, res, next) {
  const providedKey = getApiKeyFromRequest(req);

  if (!providedKey || providedKey !== env.apiKey) {
    return res.status(401).json({
      message: 'La API key es inválida o no fue enviada',
      code: 'INVALID_API_KEY'
    });
  }

  return next();
}

module.exports = {
  validateApiKey
};
