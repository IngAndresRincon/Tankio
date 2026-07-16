const balanceService = require("./balance.service");

exports.getbalancemovementsbyuser = async (req, res, next) =>{
  try {
    const id = parseInt(req.params.userid);
    const response = await balanceService.getbalancemovementsbyuser(id);

    return res.status(200).json({
      message: "Balance movements retrieved successfully",
      data: response,
    });
  } catch (error) {
    return next(error);
  }
}

exports.getbalancegroupbyuser = async (req, res, next) =>{
  try {
    const id = parseInt(req.params.userid);
    const response = await balanceService.getbalancegroupbyuser(id);

    return res.status(200).json({
      message: "Group balance retrieved successfully",
      data: response,
    });
  } catch (error) {
    return next(error);
  }
}

exports.getbalancebyid = async (req, res, next) =>{
  try {
    const id = parseInt(req.params.balanceid);
    const response = await balanceService.getbalancebyid(id);

    return res.status(200).json({
      message: "Balance retrieved successfully",
      data: response,
    });
  } catch (error) {
    return next(error);
  }
}
