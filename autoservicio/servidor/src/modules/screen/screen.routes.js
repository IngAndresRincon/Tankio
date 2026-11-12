const { Router } = require('express');
const controller = require('./screen.controller');

const router = Router();


router.post('/authentication', controller.authentication);




module.exports = router;
