const { Router } = require('express');
const controller = require('./station.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.get('/dispenser/position/:code', validateApiKey, controller.dispenserpositionbycode);
router.get('/dispenser/payment-gateway/:positioncode', validateApiKey, controller.dispenserpaymentgateway);
router.get('/', validateApiKey, controller.getstationlocations);
router.get('/payment-gateway', validateApiKey, controller.getpaymentgatewayfromstation);








module.exports = router;
