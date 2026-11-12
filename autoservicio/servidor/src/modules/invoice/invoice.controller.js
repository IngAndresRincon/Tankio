const invoiceService = require('./invoice.service');


exports.requestAnInvoice = async (req, res, next) => {
  try {
    
    const {saleId} = req.params;

    const id = parseInt(saleId);

    const result = await invoiceService.requestInvoice(id);
  
    return res.status(200).json({
      message: 'Solicitud de factura procesada correctamente',
      data: result,
    });



  } catch (error) {
    return next(error);
  }
};


exports.updatecustomerdetails = async (req, res, next) => {
  try {
    
    const {saleId} = req.params;

    const id = parseInt(saleId);
    const payload = req.body;

    const result = await invoiceService.updateCustomerDetails(id,payload);
  
    return res.status(200).json({
      message: 'Datos del cliente actualizados correctamente',
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};



exports.defaultinvoice = async (req, res, next) => {
  try {
    
    const {saleId} = req.params;

    const id = parseInt(saleId);
    const result = await invoiceService.defaultInvoice(id);

    return res.status(200).json({
        message: 'Factura a consumidor final procesada correctamente',
        data: result,
      });

  } catch (error) {
    return next(error);
  }

}



exports.printsale = async (req, res, next) => {
  try {
    
    const {saleId} = req.params;

    const id = parseInt(saleId);
    const result = await invoiceService.printSale(id);

    return res.status(200).json({
        message: 'Factura a consumidor final procesada correctamente',
        data: result,
      });

  } catch (error) {
    return next(error);
  }

}

