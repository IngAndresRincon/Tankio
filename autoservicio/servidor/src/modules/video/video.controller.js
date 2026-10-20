const videoService = require('./video.service');

const path = require('path');
const fs = require('fs/promises');
const videoDir = path.join(__dirname, '../../../public/video');

exports.defaultvideo = async (req, res, next) => {
  try {
    const screenId = Number(req.query.screenId);
    if (!Number.isSafeInteger(screenId) || screenId <= 0) {
      return res.status(400).json({ message: 'Debe enviar un screenId valido.' });
    }
    if (screenId !== Number(req.station.id)) {
      return res.status(403).json({ message: 'La pantalla no corresponde al dispositivo autenticado.' });
    }
    const dataVideo = await videoService.getVideoName(screenId);
    if(!dataVideo){
        return res.status(404).json({
        message: 'La pantalla no tiene un video configurado.',
      });
    }
    const videoName = dataVideo.nombre;
    if (!videoName || videoName !== path.basename(videoName) || /[\\/\x00]/.test(videoName)) {
      return res.status(400).json({ message: 'El nombre del video configurado no es valido.' });
    }
    const defaultVideoPath = path.join(videoDir, videoName);

    const video = await fs.stat(defaultVideoPath);
    if (!video.isFile()) {
      return res.status(404).json({ message: 'El archivo de video configurado no existe.' });
    }

    return res.set('Cache-Control', 'no-store').status(200).json({
      message: 'Video predeterminado obtenido correctamente',
      data: {
        url: `${req.protocol}://${req.get('host')}/video/${encodeURIComponent(videoName)}`,
        version: `${videoName}:${video.size}:${video.mtimeMs}`,
        size: video.size,
        configurationId: dataVideo.id,
        revision: dataVideo.revision,
        pendingSynchronization: dataVideo.sincronizar === true,
      },
    });
  } catch (error) {
    if (error.code === 'ENOENT') {
      return res.status(404).json({ message: 'El archivo de video configurado no existe.' });
    }
    return next(error);
  }
};

exports.confirm = async (req, res, next) => {
  try {
    const { screenId, configurationId, revision, version } = req.body ?? {};
    if (!Number.isSafeInteger(screenId) || screenId <= 0 ||
        !Number.isSafeInteger(configurationId) || configurationId <= 0 ||
        typeof revision !== 'string' || !/^[a-f0-9]{32}$/.test(revision) ||
        typeof version !== 'string' || !version) {
      return res.status(400).json({ message: 'La confirmacion del video no es valida.' });
    }
    if (screenId !== Number(req.station.id)) {
      return res.status(403).json({ message: 'La pantalla no corresponde al dispositivo autenticado.' });
    }
    const configuredVideo = await videoService.getVideoName(screenId);
    if (!configuredVideo || Number(configuredVideo.id) !== configurationId || configuredVideo.revision !== revision) {
      return res.status(409).json({ message: 'La configuracion cambio. Debe sincronizar nuevamente.' });
    }
    const name = configuredVideo.nombre;
    if (!name || name !== path.basename(name) || /[\\/\x00]/.test(name)) {
      return res.status(400).json({ message: 'El nombre del video configurado no es valido.' });
    }
    const file = await fs.stat(path.join(videoDir, name));
    if (!file.isFile() || version !== `${name}:${file.size}:${file.mtimeMs}`) {
      return res.status(409).json({ message: 'El archivo cambio. Debe sincronizar nuevamente.' });
    }
    const confirmed = await videoService.confirmSynchronization(screenId, configurationId, revision);
    if (!confirmed) {
      return res.status(409).json({ message: 'La configuracion cambio. Debe sincronizar nuevamente.' });
    }
    return res.status(200).json({ message: 'Video sincronizado correctamente.' });
  } catch (error) {
    if (error.code === 'ENOENT') {
      return res.status(404).json({ message: 'El archivo de video configurado no existe.' });
    }
    return next(error);
  }
};
