const programmingService = require("./programming.service");

exports.createprogramming = async (req, res, next) => {
  try {
    
    const bodyProgramming = req.body;
    const programming = await programmingService.createprogramming(bodyProgramming);

    return res.status(201).json({
      message: "Programming created successfully",
      data: programming,
    });
  } catch (error) {
    return next(error);
  }
};

exports.getprogrammingbyuser = async (req, res, next) => {
  try {
    
    const id = parseInt(req.params.userid);
    const programming = await programmingService.getprogrammingbyuser(id);

    return res.status(200).json({
      message: "Programming records retrieved successfully",
      data: programming,
    });
  } catch (error) {
    return next(error);
  }
};


exports.changestatusprogramming = async (req, res, next) => {
  try {
    
    const uuidid = req.params.uuid;
    const {programming_status_id} = req.body;
    const response = await programmingService.changestatusprogramming(uuidid,parseInt(programming_status_id));

    return res.status(200).json({
      message: "Programming status updated successfully",
      data: response,
    });
  } catch (error) {
    return next(error);
  }
};

exports.getactivitybyuser = async (req, res, next) => {
  try {
    
    const id = parseInt(req.params.userid);
    const response = await programmingService.getactivitybyuser(id);

    return res.status(200).json({
      message: "Programming status updated successfully",
      data: response,
    });
  } catch (error) {
    return next(error);
  }
};