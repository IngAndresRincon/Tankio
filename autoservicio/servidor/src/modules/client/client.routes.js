const { Router } = require('express');
const controller = require('./client.controller');
const { validateToken } = require('../../middlewares/screen-auth.middleware');


const router = Router();

router.post('/without-validation', validateToken, controller.withoutValidation);
router.post('/:identifier', validateToken, controller.validateIdentifier);

module.exports = router;
