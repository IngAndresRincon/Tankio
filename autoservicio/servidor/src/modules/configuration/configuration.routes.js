const { Router } = require('express');
const controller = require('./configuration.controller');
const { validateToken } = require('../../middlewares/screen-auth.middleware');
const router = Router();

router.get('/products', validateToken, controller.findproducts);
router.put('/products/:productId',validateToken, controller.updateproduct);
router.get('/payment-methods/:screenId', validateToken, controller.findpaymentmethods);
router.patch('/payment-methods/:paymentMethodId', validateToken, controller.updatepaymentmethod);
router.get('/image-banner',validateToken, controller.imagebanner);
router.get('/video',validateToken, controller.video);
router.patch('/video/:screenId',validateToken, controller.changevideo);


module.exports = router;
