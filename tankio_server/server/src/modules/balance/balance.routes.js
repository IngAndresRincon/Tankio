const { Router } = require('express');
const controller = require('./balance.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.get('/movements/:userid', validateApiKey, controller.getbalancemovementsbyuser);
router.get('/group/:userid', validateApiKey, controller.getbalancegroupbyuser);
router.get('/:balanceid', validateApiKey, controller.getbalancebyid);


module.exports = router;
