const userRoutes = require('../modules/user/user.routes');
const vehicleRoutes = require('../modules/vehicle/vehicle.routes');
const stationRoutes = require('../modules/station/station.routes');
const programmingRoutes = require('../modules/programming/programming.routes');
const chargercontroller = require('../modules/charger-controller/charger.routes');
const notificationcontroller = require('../modules/notification/notification.routes');
const salecontroller = require('../modules/sale/sale.routes');
const paymentGatewayRoutes = require('../modules/payment-gateway/payment-gateway.routes');
const balanceRoutes = require('../modules/balance/balance.routes');
const userWebRoutes = require('../web/user/user.routes');
const groupWebRoutes = require('../web/group/group.routes');
const paymentWebRoutes = require('../web/payment/payment.routes');
const balanceWebRoutes = require('../web/balance/balance.routes');




function registerRoutes(app) {
  app.use('/api/sandbox.tankio/v1/user', userRoutes);
  app.use('/api/sandbox.tankio/v1/vehicle', vehicleRoutes);
  app.use('/api/sandbox.tankio/v1/station', stationRoutes);
  app.use('/api/sandbox.tankio/v1/programming', programmingRoutes);
  app.use('/api/sandbox.tankio/v1/charger-controller', chargercontroller);
  app.use('/api/sandbox.tankio/v1/notification', notificationcontroller);
  app.use('/api/sandbox.tankio/v1/sale', salecontroller);
  app.use('/api/sandbox.tankio/v1/payment-gateway', paymentGatewayRoutes);
  app.use('/api/sandbox.tankio/v1/balance', balanceRoutes);
  app.use('/api/sandbox.tankio/v1/web/user', userWebRoutes);
  app.use('/api/sandbox.tankio/v1/web/group', groupWebRoutes);
  app.use('/api/sandbox.tankio/v1/web/payment', paymentWebRoutes);
  app.use('/api/sandbox.tankio/v1/web/balance', balanceWebRoutes);


}

module.exports = {
  registerRoutes
};
