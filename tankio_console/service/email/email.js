const nodemailer = require("nodemailer");
//const email = require("../../services/email/configuration").config;
const fs = require("fs");
const path = require("path");
const encrypter = require("../../utils/encrypter");
const {env} = require('../../config/env');

const handlebars = require("handlebars");

function renderTemplate(templateName, data) {
  const templatePath = path.join(
    __dirname,
    "templates",
    `${templateName}.html`,
  );

  const html = fs.readFileSync(templatePath, "utf8");
  const template = handlebars.compile(html);

  return template(data);
}

const transporter = nodemailer.createTransport({

 host: encrypter.desencrypter(env.mail.mail_host),
  port: env.mail.mail_port,
  secure: false, // 👈 MUY IMPORTANTE para STARTTLS
  auth: {
    user: encrypter.desencrypter(env.mail.mail_user),
    pass: encrypter.desencrypter(env.mail.mail_pass),
  },
  tls: {
    rejectUnauthorized: false, // 👈 útil si el certificado es interno
  },

  // host: encrypter.desencrypter(email.SMTP_HOST), //process.env.SMTP_HOST,
  // port: email.SMTP_PORT, // Number(process.env.SMTP_PORT),
  // secure: false, // 👈 MUY IMPORTANTE para STARTTLS
  // auth: {
  //   user: encrypter.desencrypter(email.SMTP_USER), // process.env.SMTP_USER,
  //   pass: encrypter.desencrypter(email.SMTP_PASS), // process.env.SMTP_PASS
  // },
  // tls: {
  //   rejectUnauthorized: false, // 👈 útil si el certificado es interno
  // },
});


async function emailNotificationRecoveryPassword(email, url) {
  let isSend = false;
  try {
    const bodyHtml = renderTemplate("notification_recovery_email", {
      url: url,
      nombre: "Sistema Inselect",
    });

    const info = await transporter.sendMail({
      from: `"Sistema Inselect" <autoatendido@insepet.com>`,
      to: email,
      subject: "Código de acceso",
      text: `Este es un email para la recuperación de tu contraseña.`,
      html: bodyHtml,
      attachments: [
        {
          filename: "logo_insepet_white.png",
          path: "C:/Users/Insepet/Documents/Insepet/Insepet/Inselect/2026/tankio_console/service/email/assets/logo-tankio-bg-removed.png",
          cid: "logoInsepet", // 👈 coincide con el src
        },
      ],
    });

    console.log("Email enviado:", info.messageId);
    if(info.accepted.length>0){
      isSend = true;
    }
    if(info.rejected.length>0){
      isSend = false;
    }
  } catch (error) {
    console.error("Error enviando email:", error);
  }
  return isSend;
}



async function emailNotificationConfirmUserEmail(email,url) {
  let isSend = false;
  try {
    const bodyHtml = renderTemplate("notification_email_confirmation", {
      url: url,
      nombre: "Sistema Inselect",
    });

    const info = await transporter.sendMail({
      from: `"Sistema Inselect" <autoatendido@insepet.com>`,
      to: email,
      subject: "Confirmación de correo",
      text: `Este es un email para confirmar que tu correo electrónico es válido.`,
      html: bodyHtml,
      attachments: [
        {
          filename: "logo_insepet_white.png",
          path: "C:/Users/Lenovo/Documents/Insepet/tankio_console/service/email/assets/logo-tankio-bg-removed.png",
          cid: "logoInsepet", // 👈 coincide con el src
        },
      ],
    });

    console.log("Email enviado:", info.messageId);
    if(info.accepted.length>0){
      isSend = true;
    }
    if(info.rejected.length>0){
      isSend = false;
    }
  } catch (error) {
    console.error("Error enviando email:", error);
  }
  return isSend;
}



module.exports = {  emailNotificationRecoveryPassword,emailNotificationConfirmUserEmail };
