const invoiceRepository = require("../repositories/invoice.repository");
const { env } = require("../config/env");
const { InvoiceService } = require("./invoice/service");
const { InvoiceAuthentication } = require("../model/Authentication");
const {Supplier, Customer } = require("../model/Invoice");

//#region FE

exports.syncGenerateInvoiceToken = async () => {
  try {
    const list = await invoiceRepository.getAvailableStationConfiguration();
    if (list.length > 0) {
      for (let i = 0; i < list.length; i++) {
        const recordRow = list[i];
        const apiKey = recordRow.api_key;
        const authModel = new InvoiceAuthentication(
          recordRow.user_name,
          recordRow.password,
          recordRow.station_id_invoice,
          recordRow.terminal_id_invoice,
        );
        console.log(authModel);

        const response = await InvoiceService(
          "post",
          "api/auth/pos/login",
          apiKey,
          authModel,
        );
        if (response.status === 201) {
          await invoiceRepository.saveToken(recordRow, response.data);
        }
        await new Promise((resolve) => setTimeout(resolve, 5000)); // Esperar 1 minuto
      }
    }
  } catch (e) {
    console.error(e.message);
  }
};



exports.syncGenereteRequestInvoiceRecord = async() =>{
    try {
        const list = await invoiceRepository.getListUnsynchronizedSales();
        if(list.length>0){
            for(let i = 0; i<list.length; i ++){
                const item = list[i];
                const result = await invoiceRepository.generateRecordInvoice(item);
                if(result){
                    await invoiceRepository.confirmRecordCreation(item);
                    await invoiceRepository.incrementSequenceValue(item);
                }
              await new Promise((resolve) => setTimeout(resolve, 3000)); // Esperar 1 minuto
            }
        }
    } catch (e) {
        console.error(e.message);
    }
}


exports.syncGenerateInvoice = async()=>{
    try {
        const list = await invoiceRepository.getListUnprocessedInvoices();
        if(list.length>0){
            for(let i =0; i< list.length; i++){
                const item = list[i];
                const itemUser = item.user_payload;

                const _supplier = new Supplier(
                    env.invoice.supplier_nit,
                    env.invoice.supplier_dv,
                    env.invoice.supplier_name)

                const _customer = new Customer(
                    itemUser.document_number,
                    itemUser.document_type_code,
                    itemUser.name,
                    itemUser.email,
                    env.invoice.department_code,
                    env.invoice.city_code,
                    env.invoice.city_name
                )

                //const itemInvoice =await GenerateItemInvoice(item);
            }
        }
    } catch (e) {
        console.error(e.message);
    }
}

//#endregion
