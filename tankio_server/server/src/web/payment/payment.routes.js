const { Router } = require('express');
const controller = require('./payment.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.get('/history', validateApiKey, controller.historypaymentrequest);

module.exports = router;
