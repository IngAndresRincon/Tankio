const { Router } = require('express');
const controller = require('./payment-gateway.controller');

const router = Router();

router.get('/webhook/epayco/validation/:ref', controller.getEpaycoReferenceValidation);
router.post('/webhook/epayco', controller.receiveEpaycoWebhook);
router.get('/webhook/wompi/validation/response', controller.getWompiReferenceValidation);
router.post('/webhook/wompi', controller.receiveWompiWebhook);
router.post('/register', controller.registerpaymentgateway);

//"/api/sandbox.tankio/v1/payment-gateway/webhook/wompi/validation/response?id=1454526-1782485694-98666&env=prod"
module.exports = router;
