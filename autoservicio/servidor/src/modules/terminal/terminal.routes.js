const { Router } = require('express');
const controller = require('./terminal.controller');
const { validateToken } = require('../../middlewares/screen-auth.middleware');
const router = Router();

router.patch('/synchronize',controller.synchronizeterminal);
router.post('/authentication',controller.authentication);


module.exports = router;
