const path = require("path");
const fs = require("fs");
const paymentService = require("./payment.service");


exports.historypaymentrequest = async (req, res, next) => {
  try {
    
    const result = await paymentService.historypaymentrequest();
    return res.status(200).json({
      message: "User list retrieved successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

