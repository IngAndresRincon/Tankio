const invoiceRepository = require('./invoice.repository');


exports.requestInvoice = async (saleId) => {
  const itemInvoice = await invoiceRepository.findInvoiceNotSent(saleId);
  if (!itemInvoice) {
    const error = new Error('La información de la factura no está disponible');
    error.statusCode = 404;
    error.code = 'INVOICE_NOT_FOUND';
    throw error;
  }


  if(itemInvoice.error || (itemInvoice.fk_id_estado_factura !==0) ){
    console.log("La factura ya se había solicitado");
  }

  const required = await invoiceRepository.requestAnInvoice(saleId);

  return itemInvoice;
};

exports.updateCustomerDetails = async (saleId, payload) => {
  const invoice = await invoiceRepository.findInvoiceNotSent(saleId);
  const dianCode = await invoiceRepository.findDocumentTypeById(payload.document_type_id);

  if(!dianCode){
    const error = new Error('El tipo de documento indicado no es válido');
    error.statusCode = 400;
    error.code = 'INVALID_DOCUMENT_TYPE';
    throw error;
  }

  payload.document_type_code = dianCode.codigo ;

  if (!invoice) {
    const error = new Error('La información de la factura no está disponible');
    error.statusCode = 404;
    error.code = 'INVOICE_NOT_FOUND';
    throw error;
  }

  const updatedInvoice = await invoiceRepository.updateCustomerDetails(saleId,payload);

  return updatedInvoice;
}

exports.defaultInvoice = async (saleId) => {
  const invoice = await invoiceRepository.findInvoiceNotSent(saleId);
  if (!invoice) {
    const error = new Error('La información de la factura no está disponible');
    error.statusCode = 404;
    error.code = 'INVOICE_NOT_FOUND';
    throw error;
  }


  const payload =  {
    "name": "Consumidor",
    "email": null,
    "user_id": null,
    "document": null,
    "last_name": "Final",
    "phone_number": null,
    "document_number": "222222222222",
    "document_type_id": 2,
    "document_type_code": "13"
  }


  const updatedInvoice = await invoiceRepository.defaultInvoice(saleId,payload);
  return updatedInvoice;
}


exports.printSale = async(saleId) =>{
  const station = await invoiceRepository.findStation();
  if(!station){
    const error = new Error('No se encontró información de la estación');
    error.statusCode = 404;
    error.code = 'STATION_NOT_FOUND';
    throw error;
  }


  const paymentMethods = await invoiceRepository.findPaymentMethods(saleId);
  if(paymentMethods.length === 0){
    const error = new Error('No se encontraron métodos de pago asociados a la venta');
    error.statusCode = 404;
    error.code = 'PAYMENT_METHODS_NOT_FOUND';
    throw error;
  }


  const sale = await invoiceRepository.findSaleById(saleId);
  if(!sale){
    const error = new Error('No se encontró información de la venta');
    error.statusCode = 404;
    error.code = 'SALE_NOT_FOUND';
    throw error;
  }


  let rows = [
    {
      Align: "center",
      text: "VOUCHER DE VENTA",
      Bold: true,
      Style: "0x9",
    },
    { Align: "center", text: "", Bold: true, Style: "0x00" },

    // Acá se configuran los datos de la estación y equipo
    {
      Align: "center",
      text: "INFORMACION DE ESTACION",
      Bold: true,
      Style: "0x00",
    },

    {
      Align: "center",
      text: station.nombre.toString().toUpperCase(),
      Bold: true,
      Style: "0x00",
    },

    {
      Align: "center",
      text: station.direccion.toString().toUpperCase(),
      Bold: true,
      Style: "0x00",
    },

    {
      Align: "center",
      text: station.telefono,
      Bold: true,
      Style: "0x00",
    },
    { Align: "center", text: "", Bold: true, Style: "0x00" },

    // Se finalizan datos de estación

    // Datos del cliente

    {
      Align: "center",
      text: "INFORMACION DE CLIENTE",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: `NOMBRE: ${sale.nombre.toString().toUpperCase()}`,
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: `IDENTIFICADOR: ${sale.identificador}`,
      Bold: true,
      Style: "0x00",
    },
    { Align: "center", text: "", Bold: true, Style: "0x00" },
    // Fin Datos del cliente
    {
      Align: "center",
      text: "CONSECUTIVO: " + sale.id_venta + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "FECHA VENTA: " + sale.fecha_venta + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "POSICION: " + sale.posicion + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "PROGRAMACION: " + sale.programacion + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "TIPO: " + sale.tipo_programacion + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "PRECIO: $" + sale.precio + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "DINERO: $" + sale.dinero + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "VOLUMEN: " + parseInt(sale.volumen) + " Gal" + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "SALDO: $" + sale.saldo + "\n",
      Bold: true,
      Style: "0x00",
    },
    {
      Align: "center",
      text: "--- FORMAS PAGO ---\n",
      Bold: true,
      Style: "0x00",
    },
  ];

  for (let i = 0; i < paymentMethods.length; i++) {
    rows.push({
      Align: "center",
      text:
        paymentMethods[i].metodo_pago +" $" +
        paymentMethods[i].monto,
      Bold: true,
      Style: "0x00",
    });
  }

  rows.push(
    {
      Align: "center",
      text: "\nPRODUCTO: " + sale.producto + "\n",
      Bold: true,
      Style: "0x00",
    },
    { Align: "center", text: "" + "\n", Bold: true, Style: "0x00" },
    {
      Align: "center",
      text: "GRACIAS POR SU VISITA" + "\n",
      Bold: true,
      Style: "0x00",
    },
    { Align: "center", text: "VUELVA PRONTO", Bold: true, Style: "0x00" }
  );


  console.log(JSON.stringify(rows));

  const isSave = await invoiceRepository.savePrintSale(JSON.stringify(rows));

  return {station,paymentMethods,sale,rows,isSave};
}

