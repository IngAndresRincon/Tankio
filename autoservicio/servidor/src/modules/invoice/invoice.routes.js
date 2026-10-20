const { Router } = require('express');
const controller = require('./invoice.controller');
const { validateToken } = require('../../middlewares/screen-auth.middleware');
const router = Router();

router.patch('/:saleId', validateToken,controller.requestAnInvoice);
router.patch('/customer-details/:saleId',validateToken, controller.updatecustomerdetails);
router.post('/default/:saleId',validateToken, controller.defaultinvoice);
router.post('/print-sale/:saleId',validateToken, controller.printsale);


module.exports = router;
