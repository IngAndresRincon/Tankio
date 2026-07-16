const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.resolve(__dirname, '../.env') });

const env = {
  url_password_recovery: process.env.URL_PASSWORD_RECOVERY,
  url_confirm_email_user: process.env.URL_CONFIRM_EMAIL_USER,
  mail:{
    mail_host:process.env.SMTP_HOST,
    mail_port:parseInt(process.env.SMTP_PORT),
    mail_user:process.env.SMTP_USER,
    mail_pass:process.env.SMTP_PASS,
  },
  sms:{
    sms_user:process.env.SMS_USER,
    sms_password:process.env.SMS_PASSWORD,
    sms_endpoint:process.env.SMS_ENDPOINT,
  },
  db: {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    host:  process.env.DB_HOST,
    port: process.env.DB_PORT,
    database:  process.env.DB_DATABASE,
    ssl: String(process.env.DB_SSL || 'false').toLowerCase() === 'true'
  },
};

module.exports = {env};
