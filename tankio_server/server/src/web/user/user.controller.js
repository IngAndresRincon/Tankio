const path = require("path");
const fs = require("fs");
const userService = require("./user.service");

// exports.register = async (req, res, next) => {
//   try {
//     const data = req.body;

//     const user = await userService.register(data);

//     return res.status(201).json({
//       message: "User registered successfully",
//       data: user,
//     });
//   } catch (error) {
//     return next(error);
//   }
// };

exports.authentication = async (req, res, next) => {
  try {
    const data = req.body;

    const result = await userService.authentication(data);

    return res.status(200).json({
      message: "User authenticated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};


exports.getlistuser = async (req, res, next) => {
  try {
    const data = req.params.userid;

    const result = await userService.getlistuser(data);

    return res.status(200).json({
      message: "User list retrieved successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};



exports.createuser = async (req, res, next) => {
  try {
    const payload = req.body;
    const result = await userService.createuser(payload);

    return res.status(200).json({
      message: "User list retrieved successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};



exports.edituser = async (req, res, next) => {
  try {
    const {userid} = req.params;
    const payload = req.body;
    const result = await userService.edituser(userid,payload);

    return res.status(200).json({
      message: "User list retrieved successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};


exports.getuserstankioapp = async (req, res, next) => {
  try {
    const result = await userService.getuserstankioapp();

    return res.status(200).json({
      message: "User authenticated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

