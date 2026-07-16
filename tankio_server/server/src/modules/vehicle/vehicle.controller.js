const vehicleService = require("./vehicle.service");

exports.register = async (req, res, next) => {
  try {
    
    const data = req.body;

    const vehicle = await vehicleService.register(data);

    return res.status(201).json({
      message: "Vehicle registered successfully",
      data: vehicle,
    });
  } catch (error) {
    return next(error);
  }
};

exports.byuserid = async (req, res, next) => {
  try {
    const userid = parseInt(req.params.userid, 10);
    const vehicle = await vehicleService.getVehiclesByUserId(userid);

    return res.status(200).json({
      message: "Vehicles retrieved successfully",
      data: vehicle,
    });
  } catch (error) {
    return next(error);
  }
};


exports.getvehicletype = async (req, res, next) => {
  try {
    
    const vehicle = await vehicleService.getvehicletype();

    return res.status(200).json({
      message: "Vehicle types retrieved successfully",
      data: vehicle,
    });
  } catch (error) {
    return next(error);
  }
};

exports.getbrandbyvehicletype = async (req, res, next) => {
  try {
    
    const type = parseInt(req.params.type);
    const vehicle = await vehicleService.getbrandbyvehicletype(type);

    return res.status(200).json({
      message: "Vehicle brands retrieved successfully",
      data: vehicle,
    });
  } catch (error) {
    return next(error);
  }
};



exports.getmodelbyvehiclebrand = async (req, res, next) => {
  try {
    
    const brand = parseInt(req.params.brand);
    const vehicle = await vehicleService.getmodelbyvehiclebrand(brand);

    return res.status(200).json({
      message: "Vehicle models retrieved successfully",
      data: vehicle,
    });
  } catch (error) {
    return next(error);
  }
};

exports.getvehicleconnector = async (req, res, next) => {
  try {
    
    const connector = await vehicleService.getvehicleconnector();

    return res.status(200).json({
      message: "Vehicle connectors retrieved successfully",
      data: connector,
    });
  } catch (error) {
    return next(error);
  }
};


exports.editvehicle = async (req, res, next) => {
  try {
    
    const id = parseInt(req.params.vehicleid);
    const edit = req.body;

    const connector = await vehicleService.editvehicle(id,edit);

    return res.status(200).json({
      message: "Vehicle updated successfully",
      data: connector,
    });
  } catch (error) {
    return next(error);
  }
};

exports.deletevehicle = async (req, res, next) => {
  try {
    
    const id = parseInt(req.params.vehicleid);
    const connector = await vehicleService.deletevehicle(id);

    return res.status(200).json({
      message: "Vehicle deleted successfully",
      data: connector,
    });
  } catch (error) {
    return next(error);
  }
};







