const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const path = require('path');
const { env } = require('./env');

const { registerRoutes } = require('../routes');
const { notFoundHandler, errorHandler } = require('../middlewares/error.middleware');
const { requestLogger } = require('../middlewares/request-logger.middleware');

const publicDir = path.resolve(__dirname, '../../public');
const audioDir = path.join(publicDir, 'audio');
const imageDir = path.join(publicDir, 'img');
const videoDir = path.join(publicDir, 'video');
const defaultVideoPath = path.join(videoDir, 'defaultvideo.mp4');
const staticOptions = {
  setHeaders(res, filePath) {
    // El MIME de .mp4 puede variar entre versiones de las dependencias.
    if (path.extname(filePath).toLowerCase() === '.mp4') {
      res.setHeader('Content-Type', 'video/mp4');
    }
  },
};


function createApp() {

  
  const app = express();

  app.disable('x-powered-by');
  app.use(requestLogger);
  app.use(helmet());
  app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'x-api-key', 'Authorization'],
  }));
  app.use(express.json({ limit: '1mb' }));
  // Recursos disponibles con su ruta física relativa a /public.
  // Ej.: /public/audio/bienvenido.mp3 y /public/img/Pantalla1.jpg
  app.use('/public/image', express.static(imageDir));
  app.use('/public', express.static(publicDir, staticOptions));

  // Alias conservados para los clientes que ya consumen estas rutas.
  app.use('/audio', express.static(audioDir));
  app.use('/image', express.static(imageDir));
  app.use('/video', express.static(videoDir, {
    ...staticOptions,
    etag: true,
    lastModified: true,
    maxAge: 0,
  }));

  // app.get('/api/sandbox.self-service/v1/video/default', (req, res) => {
  //   if (!require('fs').existsSync(defaultVideoPath)) {
  //     return res.status(404).json({
  //       message: 'No existe el video predeterminado.',
  //     });
  //   }

  //   const video = require('fs').statSync(defaultVideoPath);

  //   return res.set('Cache-Control', 'no-store').json({
  //     url: `${req.protocol}://${req.get('host')}/video/defaultvideo.mp4`,
  //     version: String(video.mtimeMs),
  //     size: video.size,
  //   });
  // });


  app.use('/version', express.static(path.join(publicDir, 'version')));

  app.use(express.urlencoded({ extended: false }));
  app.use(morgan('dev'));
  app.use(express.static(publicDir, staticOptions));

  registerRoutes(app);

  app.use(notFoundHandler);
  app.use(errorHandler);

  app.set('port', env.port);
  app.set('views', path.join(__dirname, '../views'));
  app.set('view engine', 'ejs');

  return app;
}

module.exports = createApp;
