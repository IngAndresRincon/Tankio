const { Router } = require('express');
const controller = require('./sale.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.post('/register/inselect', validateApiKey, controller.registersaleinselect);
router.get('/:userid', validateApiKey, controller.getsalebyuser);
router.get('/invoice/:saleid',validateApiKey, controller.getinvoicebysale);
//router.get('/register/tankio', validateApiKey, controller.registersaletankio);








module.exports = router;
