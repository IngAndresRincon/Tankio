const invoiceRepository = require("../repositories/invoice.repository");
const { env } = require("../config/env");
const { InvoiceService ,GenerateInvoice} = require("./invoice/service");
const { InvoiceAuthentication } = require("../model/Authentication");
const {Supplier, Customer,Taxes ,Items,Payments,Invoice} = require("../model/Invoice");

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


exports.syncGeneratePayloadInvoice = async()=>{
    try {
        const list = await invoiceRepository.getListUnprocessedInvoices(0);
        if(list.length>0){         

            for(let i =0; i< list.length; i++){
                const item = list[i];
                const invoice = await processInvoiceInformation(item);
                if(!invoice) continue;
                await invoiceRepository.savePayloadRequestInvoice(item, invoice);
                await new Promise((resolve) => setTimeout(resolve, 1000)); // Esperar 1 minuto
                //const itemInvoice =await GenerateItemInvoice(item);
            }
        }
    } catch (e) {
        console.error(e.message);
    }
}


async function processInvoiceInformation(invoice){

  let _invoice = null;

  try {    
          const itemUser = invoice.user_payload;
          const itemSale = invoice.sale_payload;

          const now = new Date(); 
          const _issueDate =generateFormatDate();
          const _issueTime =generateFormatTime(); // `${now.getHours()}:${now.getMinutes()}:${now.getSeconds()}`;
          const _currency = env.invoice.currency;
          
          let _taxes = [];
          const productTaxes = await invoiceRepository.getTaxesByProduct(itemSale.product_id);
          if(productTaxes.length >0){
              productTaxes.forEach(e => {
                _taxes.unshift(new Taxes(e.tax_code,e.percentage_value,env.invoice.tax_treatment_default))
              });
          }

          let _items = [];

          _items.unshift(
            new Items(
              itemSale.id,
              itemSale.product_code,
              itemSale.product_name,
              itemSale.power,
              env.invoice.energy_unit_code,
              itemSale.price,
              itemSale.money,
              itemSale.money,
              _taxes
            ) );

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
          
          let _payment = [];

          _payment.unshift(new Payments(
            env.invoice.default_payment_form,
            env.invoice.default_payment_method,
            itemSale.money
          ));
          


          _invoice = new Invoice(
          itemSale.uuid,
          _issueDate,
          _issueTime,
          env.invoice.currency,
          _supplier,
          _customer,
          _items,
          _payment,
          `Venta: ${itemSale.id} | Placa: ${itemSale.identifier}`
        );

  } catch (e) {
    console.error(e.message);
  }

  return _invoice;
}


function generateFormatDate(){
  const now = new Date(); 

  const _year =now.getFullYear();
  let _unformattedMonth = parseInt(now.getMonth())+1;
  const _month =_unformattedMonth.toString().length ===1 ? `0${_unformattedMonth}` :_unformattedMonth;
  let _unformattedDay = now.getDate();
  const _day = _unformattedDay.toString().length ===1?`0${_unformattedDay}`:_unformattedDay;

  return `${_year}-${_month}-${_day}`;

}

function generateFormatTime(){
  const now = new Date(); 
  const _unformattedHour =now.getHours();
  const _hour = _unformattedHour.toString().length ===1? `0${_unformattedHour}`:_unformattedHour;

  const _unformattedMinutes = now.getMinutes();
  const _minutes = _unformattedMinutes.toString().length ===1 ? `0${_unformattedMinutes}`: _unformattedMinutes;

  const _unformattedSeconds = now.getSeconds();
  const _seconds = _unformattedSeconds.toString().length ===1? `0${_unformattedSeconds}`: _unformattedSeconds;


  return `${_hour}:${_minutes}:${_seconds}`;

}


exports.syncRequestInvoice = async() =>{
   try {
        const list = await invoiceRepository.getListUnprocessedInvoices(1);
        if(list.length>0){
          for(let i=0; i< list.length; i++){
            const item = list[i];
            const stationConfig = await invoiceRepository.getStationInvoiceConfiguration(item.station_id);
            const endpoint = `api/operations/invoices?stationId=${stationConfig.station_id_invoice}`;
            const response = await GenerateInvoice('post',endpoint,stationConfig,item.request_invoice_payload);
          }

        }
    } catch (e) {
        console.error(e.message);
    }
}

//#endregion
