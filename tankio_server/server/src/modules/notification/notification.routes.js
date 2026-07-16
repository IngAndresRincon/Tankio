const { Router } = require('express');
const controller = require('./notification.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.get('/:userid', validateApiKey, controller.notificationsbyuser);


module.exports = router;
