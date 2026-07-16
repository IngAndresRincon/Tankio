const { Router } = require('express');
const controller = require('./balance.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.get('/', validateApiKey, controller.getbalancebyuser);

module.exports = router;
