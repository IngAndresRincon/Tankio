const { Router } = require('express');
const controller = require('./group.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.get('/', validateApiKey, controller.getlistgroup);

module.exports = router;
