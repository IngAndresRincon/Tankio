const path = require('path');
const dotenv = require('dotenv');
const { desencrypter } = require('../../utils/encrypter');
dotenv.config({ path: path.resolve(__dirname, '../../.env') ,quiet: true});

const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  db: {
    user: desencrypter(process.env.DB_USER),
    password: desencrypter(process.env.DB_PASSWORD),
    host:  process.env.DB_HOST,
    port: process.env.DB_PORT,
    database:  process.env.DB_DATABASE,
    ssl: String(process.env.DB_SSL || 'false').toLowerCase() === 'true'
  }, 
  terminal:{
    urlpayment: process.env.TERMINAL_URL_PAYMENT,
    urlstatus: process.env.TERMINAL_URL_STATUS
  }
};

module.exports = {env};
