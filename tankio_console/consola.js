
const fs = require("fs");
const serviceConsole = require('./service/console.service');


async function startConsole() {
  syncBalanceMovement();
  syncPasswordRecoveryNotification();
  syncDisablePasswordRecoveryURL()
  syncReleaseProgramming();
  syncNotifications();
  syncSaleCompletedNotification();
  syncNotifyEmailConfirmation();
}


//#region 

async function syncBalanceMovement() {
  
  while (true) {
    try {
      await serviceConsole.syncBalanceMovement();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 2000)); // Esperar 1 segundos
  }
  
}
async function syncPasswordRecoveryNotification() {
  
  while (true) {
    try {
      await serviceConsole.syncRecoveryPasswordNotification();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 5000)); // Esperar 1 segundos
  }
  
}

async function syncDisablePasswordRecoveryURL() {
  
  while (true) {
    try {
      await serviceConsole.syncDisablePasswordRecoveryURL();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 20000)); // Esperar 1 minuto
  }
  
}

async function syncReleaseProgramming() {
  
  while (true) {
    try {
      await serviceConsole.syncReleaseProgramming();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 5000)); // Esperar 1 minuto
  }
  
}


async function syncNotifications() {

  while (true) {
    try {
      await serviceConsole.syncNotifications();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}

async function syncSaleCompletedNotification() {

  while (true) {
    try {
      await serviceConsole.syncSaleCompletedNotification();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}

async function syncNotifyEmailConfirmation() {

  while (true) {
    try {
      await serviceConsole.syncNotifyEmailConfirmation();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}





//#endregion
startConsole();