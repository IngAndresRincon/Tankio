const { Router } = require('express');
const controller = require('./programming.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.post('/create', validateApiKey, controller.createprogramming);
router.get('/:userid', validateApiKey, controller.getprogrammingbyuser);
router.patch('/status/:uuid', validateApiKey, controller.changestatusprogramming);
router.get('/activity/:userid', validateApiKey, controller.getactivitybyuser);







module.exports = router;
