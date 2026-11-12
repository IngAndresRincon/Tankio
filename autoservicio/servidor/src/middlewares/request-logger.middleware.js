const { writeServiceLog } = require('../common/service-logger');

function requestLogger(req, res, next) {
  if (!req.path.startsWith('/api/')) {
    return next();
  }

  const startedAt = process.hrtime.bigint();

  res.on('finish', () => {
    const durationMs = Number(process.hrtime.bigint() - startedAt) / 1_000_000;
    const error = res.locals.logError;

    void writeServiceLog({
      level: res.statusCode >= 500 ? 'ERROR' : res.statusCode >= 400 ? 'WARN' : 'INFO',
      event: 'HTTP_REQUEST',
      method: req.method,
      path: req.path,
      status: res.statusCode,
      durationMs: Number(durationMs.toFixed(2)),
      code: error?.code,
      message: error?.message,
    });
  });

  return next();
}

module.exports = { requestLogger };
