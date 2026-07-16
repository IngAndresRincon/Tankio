const crypto = require('crypto');

function generateApiKey(bytes = 32) {
  return crypto.randomBytes(bytes).toString('hex');
}

module.exports = {
  generateApiKey
};
