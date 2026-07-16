const notificationService = require("./notification.service");

exports.notificationsbyuser = async (req, res, next) =>{
  try {
    const id = req.params.userid;
    const response = await notificationService.notificationsbyuser(id);

    return res.status(200).json({
      message: "Notifications retrieved successfully",
      data: response,
    });
  } catch (error) {
    return next(error);
  }
}
