const videoRepository = require('./video.repository');


exports.getVideoName = async (screenId) => {
  return await videoRepository.getVideoName(screenId);
};

exports.confirmSynchronization = async (screenId, configurationId, revision) => {
  return await videoRepository.confirmSynchronization(screenId, configurationId, revision);
};
