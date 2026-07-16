const repositoryConsole = require("../repositories/console.repository");
const { env } = require("../config/env");
const { randomInt } = require("crypto");
const email = require("./email/email");
const sms = require("./sms/sms");


exports.syncBalanceMovement = async () => {
  try {
    const movement = await repositoryConsole.getBalanceMovement();
    if (movement.length > 0) {
      for (let i = 0; i < movement.length; i++) {
        let confirmedMovement = false;

        switch (movement[i].balance_movement_type_id) {
          case 1:
            confirmedMovement = await repositoryConsole.syncMovementRecharge(
              movement[i],
            );
            break;
          case 2:
            confirmedMovement = await repositoryConsole.syncMovementPurchase(
              movement[i],
            );
            break;
          case 3:
            confirmedMovement = await repositoryConsole.syncMovementRetained(
              movement[i],
            );
            break;
          case 4:
            confirmedMovement = await repositoryConsole.syncMovementReturn(
              movement[i],
            );
            break;
          case 5:
            confirmedMovement = true;
            break;
          default:
            break;
        }
        if (confirmedMovement) {
          await repositoryConsole.confirmMovement(movement[i]);
        }
      }
    }
  } catch (error) {
    console.log(error);
    return false;
  }

  return true;
};

exports.syncRecoveryPasswordNotification = async () => {
  try {
    const records = await repositoryConsole.getListPendingRecoveryPassword();
    if (records.length > 0) {
      for (let i = 0; i < records.length; i++) {
        const e = records[i];
        const code = await generateDynamicCode();
        const url = `${env.url_password_recovery}${code}`;
        const isSentEmail = await email.emailNotificationRecoveryPassword(e.email, url);
        await repositoryConsole.confirmSendingEmail(isSentEmail, e, code, url);
      }
    }
  } catch (error) {
    console.log(error);
    return false;
  }

  return true;
};

async function generateDynamicCode() {
  return String(randomInt(100000, 1000000));
}

exports.syncDisablePasswordRecoveryURL = async () => {
  const list = await repositoryConsole.getListRecoveryUrl();
  if (list.length > 0) {
    for (let i = 0; i < list.length; i++) {
      const item = list[i];
      await repositoryConsole.disableItemRecovery(item);
    }
  }
};



exports.syncReleaseProgramming = async () => {
  const list = await repositoryConsole.getListReleaseProgramming();
  if (list.length > 0) {
    for (let i = 0; i < list.length; i++) {
      const item = list[i];
      await repositoryConsole.releaseProgramming(item);
    }
  }
}


exports.syncNotifications = async () => {
  const list = await repositoryConsole.getListNotifications(); 
  if (list.length > 0) {
    for (let i = 0; i < list.length; i++) {
      const item = list[i];
      await repositoryConsole.sendNotification(item);
    }
  }
}


exports.syncSaleCompletedNotification = async () => {
  const list = await repositoryConsole.getSaleCompleted(); 
  if (list.length > 0) {
    for (let i = 0; i < list.length; i++) {
      const sale = list[i];
      const notification = {
        "phonenumber":sale.phone_number,
        "message":generateMessageSMS(sale)
      }
      const result = await sms.SMSService(notification);
      repositoryConsole.confirmNotificationSending(sale);
    }
  }
}

function generateMessageSMS(sale){
  return `El sistema Tankio acaba de completar una venta de carga eléctrica por valor de: $${sale.money} el día: ${sale.final_date_sale}`;
}




exports.syncNotifyEmailConfirmation = async () => {
  const list = await repositoryConsole.getListNotifyEmail(); 
  if (list.length > 0) {
    const itemUser = list[0];
     const url = `${env.url_confirm_email_user}${itemUser.id}/${itemUser.email}`;
    const isSentEmail = await email.emailNotificationConfirmUserEmail(itemUser.email,url);
    if(isSentEmail){
        await repositoryConsole.confirmSendingEmailUser(itemUser);
    }
  }
}

