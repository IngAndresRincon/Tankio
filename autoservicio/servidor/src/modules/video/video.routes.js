const { Router } = require('express');
const controller = require('./video.controller');
const { validateToken } = require('../../middlewares/screen-auth.middleware');

const router = Router();


router.get('/default', validateToken, controller.defaultvideo);
router.post('/confirm', validateToken, controller.confirm);




module.exports = router;
