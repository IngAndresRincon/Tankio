const chargerService = require("./charger.service");

exports.authentication = async (req, res, next) =>{
  try {
    const module = req.body;
    const response = await chargerService.findControllerCharger(module);


    res.status(200).json({
      isError: false,
      message: "Controller authenticated successfully",
      content: response
    });
  } catch (error) {
    return next(error);
  }
}


exports.updatestatus = async (req, res, next) =>{
  try {

    const positionid = req.params.positionid;

    const body = req.body;
    const response = await chargerService.updatestatus(positionid,body);


    res.status(200).json({
      isError: false,
      message: "Position status updated successfully",
      content: response
    });
  } catch (error) {
    return next(error);
  }
}
