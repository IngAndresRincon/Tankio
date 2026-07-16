const path = require("path");
const fs = require("fs");
const balanceService = require("./balance.service");


exports.getbalancebyuser = async (req, res, next) => {
  try {
    const result = await balanceService.getbalancebyuser();

    return res.status(200).json({
      message: "User authenticated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};


