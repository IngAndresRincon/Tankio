const mappingRoutes = require('../modules/mapping/mapping.routes');
const screenRoutes = require('../modules/screen/screen.routes');
const clientRoutes = require('../modules/client/client.routes');
const programmingRoutes = require('../modules/programming/programming.routes');
const videoRoutes = require('../modules/video/video.routes');
const invoiceRoutes = require('../modules/invoice/invoice.routes');
const configurationRoutes = require('../modules/configuration/configuration.routes');
const terminal = require('../modules/terminal/terminal.routes');




function registerRoutes(app) {
  app.use('/api/sandbox.self-service/v1/screen', screenRoutes);
  app.use('/api/sandbox.self-service/v1/mapping', mappingRoutes);
  app.use('/api/sandbox.self-service/v1/client', clientRoutes);
  app.use('/api/sandbox.self-service/v1/programming', programmingRoutes);
  app.use('/api/sandbox.self-service/v1/video', videoRoutes);
  app.use('/api/sandbox.self-service/v1/invoice', invoiceRoutes);
  app.use('/api/sandbox.self-service/v1/configuration', configurationRoutes);
  app.use('/api/terminal', terminal);
}

module.exports = {
  registerRoutes
};
