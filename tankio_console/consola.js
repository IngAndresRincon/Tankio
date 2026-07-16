const fs = require("fs");
const consoleService = require("./service/console.service");
const invoiceService = require("./service/invoice.service");

async function startConsole() {
  syncBalanceMovement();
  syncPasswordRecoveryNotification();
  syncDisablePasswordRecoveryURL();
  syncReleaseProgramming();
  syncNotifications();
  syncSaleCompletedNotification();
  syncNotifyEmailConfirmation();
  syncGenerateInvoiceToken();
  syncGenerateRequestInvoiceRecord();
  syncGenerateInvoice();
}

//#region

async function syncBalanceMovement() {
  while (true) {
    try {
      await consoleService.syncBalanceMovement();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 2000)); // Esperar 1 segundos
  }
}

//#endregion
async function syncPasswordRecoveryNotification() {
  while (true) {
    try {
      await consoleService.syncRecoveryPasswordNotification();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 5000)); // Esperar 1 segundos
  }
}

async function syncDisablePasswordRecoveryURL() {
  while (true) {
    try {
      await consoleService.syncDisablePasswordRecoveryURL();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 20000)); // Esperar 1 minuto
  }
}

async function syncReleaseProgramming() {
  while (true) {
    try {
      await consoleService.syncReleaseProgramming();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 5000)); // Esperar 1 minuto
  }
}

async function syncNotifications() {
  while (true) {
    try {
      await consoleService.syncNotifications();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}

async function syncSaleCompletedNotification() {
  while (true) {
    try {
      await consoleService.syncSaleCompletedNotification();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}

async function syncNotifyEmailConfirmation() {
  while (true) {
    try {
      await consoleService.syncNotifyEmailConfirmation();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}

//#region FE

async function syncGenerateInvoiceToken() {
  while (true) {
    try {
      await invoiceService.syncGenerateInvoiceToken();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 20000)); // Esperar 1 minuto
  }
}

async function syncGenerateRequestInvoiceRecord() {
  while (true) {
    try {
      await invoiceService.syncGenereteRequestInvoiceRecord();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}

async function syncGenerateInvoice() {
  while (true) {
    try {
      await invoiceService.syncGenerateInvoice();
    } catch (error) {
      console.error(error);
    }
    await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 1 minuto
  }
}

//#endregion
startConsole();
