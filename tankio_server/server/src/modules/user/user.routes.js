const { Router } = require('express');
const controller = require('./user.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();

router.post('/authentication', validateApiKey, controller.authentication);
router.post('/register', validateApiKey, controller.register);
router.patch('/edit/:userid', validateApiKey, controller.edit);
router.get('/terms&conditions/:userid', validateApiKey, controller.termsconditions);
router.post('/terms&conditions', validateApiKey, controller.registertermsconditions);
router.patch('/change-password/:userid', validateApiKey, controller.changepassword);
router.post('/token-refresh', validateApiKey, controller.validtokenrefresh);
router.get('/password-recovery-url/:code', controller.passwordrecoveryurl);
router.post('/password-recovery/update', controller.passwordrecoveryupdate);
router.post('/password-recovery/:email', validateApiKey, controller.passwordrecoverybyemail);
router.delete('/delete-account/:userid', validateApiKey, controller.deleteaccount);
router.get('/confirm-email/:userid', controller.confirmemailuser);






module.exports = router;
