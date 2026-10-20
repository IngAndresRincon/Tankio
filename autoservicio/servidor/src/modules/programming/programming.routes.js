const { Router } = require('express');
const controller = require('./programming.controller');
const { validateToken } = require('../../middlewares/screen-auth.middleware');

const router = Router();


router.get('/last-sale/:screenId', validateToken,controller.lastsale);
router.get('/:programmindId/sale', validateToken,controller.lastsalebyprogramming);
router.get('/products/:productId', validateToken,controller.availableproducts);
router.get('/:userId/:screenId', validateToken,controller.findpendingprogramming);
router.post('/', validateToken,controller.createprogramming);
router.post('/payment', validateToken, controller.createpayment);
router.patch('/cancel-payment/:transactionId', validateToken, controller.cancelpayment);
router.patch('/authorize/:programmingId', validateToken, controller.authorizeprogramming);
router.patch('/change-product/:productId/:programmingId', validateToken, controller.changeproduct);







module.exports = router;
