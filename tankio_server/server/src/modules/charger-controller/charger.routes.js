const { Router } = require('express');
const controller = require('./charger.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.post('/authentication', validateApiKey, controller.authentication);
router.patch('/position/status/:positionid', validateApiKey, controller.updatestatus);


module.exports = router;
