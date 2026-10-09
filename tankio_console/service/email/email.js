const nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");
const handlebars = require("handlebars");

const encrypter = require("../../utils/encrypter");
const { env } = require("../../config/env");


// ======================================================
// RUTAS
// ======================================================

const ASSETS_PATH = path.join(__dirname, "assets");

const LOGO_PATH = path.join(
  ASSETS_PATH,
  "logo-tankio-bg-removed.png"
);


// ======================================================
// TEMPLATE HTML
// ======================================================

function renderTemplate(templateName, data) {

  const templatePath = path.join(
    __dirname,
    "templates",
    `${templateName}.html`
  );

  // Validamos que el template exista
  if (!fs.existsSync(templatePath)) {
    throw new Error(
      `No se encontró el template de email: ${templatePath}`
    );
  }

  const html = fs.readFileSync(templatePath, "utf8");

  const template = handlebars.compile(html);

  return template(data);
}


// ======================================================
// TRANSPORTER NODEMAILER
// ======================================================

const transporter = nodemailer.createTransport({

  host: encrypter.desencrypter(
    env.mail.mail_host
  ),

  port: env.mail.mail_port,

  secure: false,

  auth: {
    user: encrypter.desencrypter(
      env.mail.mail_user
    ),

    pass: encrypter.desencrypter(
      env.mail.mail_pass
    ),
  },

  tls: {
    rejectUnauthorized: false,
  },

});


// ======================================================
// ATTACHMENTS
// ======================================================

function getEmailAttachments() {

  // Validamos que el logo realmente exista
  if (!fs.existsSync(LOGO_PATH)) {

    console.error(
      "No se encontró el logo del email:"
    );

    console.error(LOGO_PATH);

    throw new Error(
      `No se encontró el logo del email: ${LOGO_PATH}`
    );
  }

  return [
    {
      filename: "logo_insepet_white.png",

      path: LOGO_PATH,

      // Debe coincidir con:
      // <img src="cid:logoInsepet">
      cid: "logoInsepet",
    },
  ];
}


// ======================================================
// RECUPERACIÓN DE CONTRASEÑA
// ======================================================

async function emailNotificationRecoveryPassword(email, url) {

  try {

    const bodyHtml = renderTemplate(
      "notification_recovery_email",
      {
        url: url,
        nombre: "Sistema Inselect",
      }
    );

    const info = await transporter.sendMail({

      from: `"Sistema Inselect" <autoatendido@insepet.com>`,

      to: email,

      subject: "Código de acceso",

      text: "Este es un email para la recuperación de tu contraseña.",

      html: bodyHtml,

      attachments: getEmailAttachments(),

    });


    console.log(
      "Email de recuperación enviado:",
      info.messageId
    );


    if (info.accepted && info.accepted.length > 0) {

      console.log(
        "Email aceptado:",
        info.accepted
      );

      return true;
    }


    if (info.rejected && info.rejected.length > 0) {

      console.error(
        "Email rechazado:",
        info.rejected
      );

    }

    return false;


  } catch (error) {

    console.error(
      "Error enviando email de recuperación:",
      error
    );

    return false;
  }
}


// ======================================================
// CONFIRMACIÓN DE CORREO
// ======================================================

async function emailNotificationConfirmUserEmail(email, url) {

  try {
    console.log(`Enviando email a: ${email}`);
    const bodyHtml = renderTemplate(
      "notification_email_confirmation",
      {
        url: url,
        nombre: "Sistema Inselect",
      }
    );

    const info = await transporter.sendMail({

      from: `"Sistema Inselect" <autoatendido@insepet.com>`,

      to: email,

      subject: "Confirmación de correo",

      text: "Este es un email para confirmar que tu correo electrónico es válido.",

      html: bodyHtml,

      attachments: getEmailAttachments(),

    });


    console.log(
      "Email de confirmación enviado:",
      info.messageId
    );


    if (info.accepted && info.accepted.length > 0) {

      console.log(
        "Email aceptado:",
        info.accepted
      );

      return true;
    }


    if (info.rejected && info.rejected.length > 0) {

      console.error(
        "Email rechazado:",
        info.rejected
      );

    }

    return false;


  } catch (error) {

    console.error(
      "Error enviando email de confirmación:",
      error
    );

    return false;
  }
}


// ======================================================
// EXPORTS
// ======================================================

module.exports = {
  emailNotificationRecoveryPassword,
  emailNotificationConfirmUserEmail,
};