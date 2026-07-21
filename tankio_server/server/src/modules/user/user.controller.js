const path = require("path");
const fs = require("fs");
const userService = require("./user.service");
const { desencrypter} = require('../../utils/encrypter');

exports.register = async (req, res, next) => {
  try {
    const data = req.body;

    const user = await userService.register(data);

    return res.status(201).json({
      message: "User registered successfully",
      data: user,
    });
  } catch (error) {
    return next(error);
  }
};

exports.authentication = async (req, res, next) => {
  try {
    const data = req.body;
    const _headers = req.headers;

    const result = await userService.authentication(data);

    return res.status(200).json({
      message: "User authenticated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.validtokenrefresh = async (req, res, next) => {
  try {
    const { token } = req.body;

    const result = await userService.validtokenrefresh(token);

    return res.status(200).json({
      message: "Token refreshed successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.edit = async (req, res, next) => {
  try {
    const id = parseInt(req.params.userid);
    const user = req.body;

    const result = await userService.edit(id, user);

    return res.status(200).json({
      message: "User updated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.termsconditions = async (req, res, next) => {
  try {
    const id = parseInt(req.params.userid);

    const result = await userService.termsconditions(id);

    return res.status(200).json({
      message: "Terms and conditions retrieved successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.registertermsconditions = async (req, res, next) => {
  try {
    const body = req.body;

    const result = await userService.registertermsconditions(body);

    return res.status(201).json({
      message: "Terms and conditions accepted successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.changepassword = async (req, res, next) => {
  try {
    const id = parseInt(req.params.userid);
    const body = req.body;

    const result = await userService.changepassword(id, body);

    return res.status(200).json({
      message: "Password changed successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.passwordrecoveryurl = async (req, res, next) => {
  try {
    const code = req.params.code;

    const isValid = await userService.validRecoveryCodePassword(code);

    if (!isValid) {
      return res.status(400).json({
        message: "Invalid recovery code",
      });
    }

    const htmlPath = path.resolve(
      __dirname,
      "../../../public/recover-password.html",
    );

    const html = fs.readFileSync(htmlPath, "utf8").replace(
      "{{user_email}}",
      isValid.email
    ).replace(
      "{{recovery_code}}",
      code
    );

    return res.status(200).type("html").send(html);
  } catch (error) {
    return next(error);
  }
};

exports.passwordrecoverybyemail = async (req, res, next) => {
  try {
    const email = req.params.email;
    const result = await userService.passwordrecoverybyemail(email);

    return res.status(200).json({
      message: "Password recovery request created successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.passwordrecoveryupdate = async (req, res, next) => {
  try {
    const data = req.body;
    const result = await userService.passwordrecoveryupdate(data);

    return res.status(200).json({
      message: "Password updated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};


exports.deleteaccount = async (req, res, next) => {
  try {
    const data = req.body;
    const {userid} = req.params;
    const result = await userService.deleteaccount(userid);

    return res.status(200).json({
      message: "Password updated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};


exports.confirmemailuser = async (req, res, next) => {
  try {
    
    const {userid} = req.params;
    const {email} = req.query;
    const normalizeEmail = desencrypter(email);
    const result = await userService.confirmemailuser(parseInt(userid),normalizeEmail);

    return res.status(200).json({
      message: "Password updated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.changecustomerdetailsinvoice = async (req, res, next) => {
  try {
    
    const {saleid} = req.params;
    const data = req.body;
    const result = await userService.changecustomerdetailsinvoice(parseInt(saleid),data);

    return res.status(200).json({
      message: "Password updated successfully",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};



