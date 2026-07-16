const { Router } = require('express');
const controller = require('./user.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.post('/authentication', validateApiKey, controller.authentication);
router.get('/users/:userid', validateApiKey, controller.getlistuser);
router.post('', validateApiKey, controller.createuser);
router.patch('/:userid', validateApiKey, controller.edituser);
router.get('/tankio-app', validateApiKey, controller.getuserstankioapp);


module.exports = router;
