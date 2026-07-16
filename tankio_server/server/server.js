const createApp = require('./src/config/app');
const {env} = require('./src/config/env');
const http = require('http');
const {createSocketServer,startPostgresListener} = require('./src/socketio/index');


const app = createApp();
const httpServer = http.createServer(app);
const io = createSocketServer(httpServer);

startPostgresListener().catch((error) => {
  console.error('[postgres-listener] start failed:', error.message);
});


httpServer.listen(env.port, () => {
  console.log(`Server running on http://localhost:${env.port}`);
});

