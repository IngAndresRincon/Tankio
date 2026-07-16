const stationService = require("./station.service");

exports.dispenserpositionbycode = async (req, res, next) => {
  try {
    
    const code = req.params.code;
    const positions = await stationService.dispenserpositionbycode(code);

    return res.status(200).json({
      message: "Dispenser positions retrieved successfully",
      data: positions,
    });
  } catch (error) {
    return next(error);
  }
};



exports.dispenserpaymentgateway = async (req, res, next) => {
  try {
    
    const {positioncode}= req.params;
    const dispayment = await stationService.dispenserpaymentgatewaybycode(positioncode);

    return res.status(200).json({
      message: "Dispenser payment gateways retrieved successfully",
      data: dispayment,
    });
  } catch (error) {
    return next(error);
  }
};


exports.getstationlocations = async (req, res, next) => {
  try {
    
    const stations = await stationService.getstationlocations();

    return res.status(200).json({
      message: "Station locations retrieved successfully",
      data: stations,
    });
  } catch (error) {
    return next(error);
  }
};


exports.getpaymentgatewayfromstation = async (req, res, next) => {
  try {
    
    const stations = await stationService.getpaymentgatewayfromstation();

    return res.status(200).json({
      message: "Payment gateways retrieved successfully",
      data: stations,
    });
  } catch (error) {
    return next(error);
  }
};
