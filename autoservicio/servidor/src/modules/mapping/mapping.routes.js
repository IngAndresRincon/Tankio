const { Router } = require('express');
const controller = require('./mapping.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');
const { validateToken } = require('../../middlewares/screen-auth.middleware');


const router = Router();
router.get('/:serial', validateToken, controller.mapping);
module.exports = router;
