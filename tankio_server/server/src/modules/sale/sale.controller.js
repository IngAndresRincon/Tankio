const saleService = require("./sale.service");

exports.registersaleinselect = async (req, res, next) => {
  try {
    
    const body = req.body;
    console.log(`JSON SALE ${JSON.stringify(body)}`);
    const sale = await saleService.registersaleinselect(body);

    return res.status(201).json({
      message: "Sale created successfully",
      data: sale,
    });
  } catch (error) {
    return next(error);
  }
};


exports.getsalebyuser = async (req, res, next) => {
  try {
    
    const id = req.params.userid;
    const sale = await saleService.getsalebyuser(id);

    return res.status(200).json({
      message: "Sale created successfully",
      data: sale,
    });
  } catch (error) {
    return next(error);
  }
};



exports.getinvoicebysale = async  (req, res, next) => {
  try {
    
    const {saleid} = req.params;
    const sale = await saleService.getinvoicebysale(saleid);

    return res.status(200).json({
      message: "Invoice",
      data: sale,
    });
  } catch (error) {
    return next(error);
  }
};