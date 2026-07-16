const { Router } = require('express');
const controller = require('./vehicle.controller');
const { validateApiKey } = require('../../middlewares/api-key.middleware');

const router = Router();


router.post('/register', validateApiKey, controller.register);
router.get('/type', validateApiKey, controller.getvehicletype);
router.get('/connector', validateApiKey, controller.getvehicleconnector);
router.get('/brand/:type', validateApiKey, controller.getbrandbyvehicletype);
router.get('/model/:brand', validateApiKey, controller.getmodelbyvehiclebrand);
router.get('/:userid', validateApiKey, controller.byuserid);
router.patch('/edit/:vehicleid', validateApiKey, controller.editvehicle);
router.delete('/delete/:vehicleid', validateApiKey, controller.deletevehicle);





module.exports = router;
