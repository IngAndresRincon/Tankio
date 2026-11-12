const fs = require('fs/promises');
const path = require('path');

const logsDir = path.resolve(__dirname, '../../logs');

function getLogFilePath() {
  const date = new Date().toISOString().slice(0, 10);
  return path.join(logsDir, `service-${date}.txt`);
}

async function writeServiceLog({ level = 'INFO', event, ...details }) {
  const timestamp = new Date().toISOString();
  const detailText = Object.entries(details)
    .filter(([, value]) => value !== undefined && value !== null && value !== '')
    .map(([key, value]) => `${key}=${JSON.stringify(value)}`)
    .join(' ');
  const line = `[${timestamp}] ${level} ${event}${detailText ? ` ${detailText}` : ''}\n`;

  try {
    await fs.mkdir(logsDir, { recursive: true });
    await fs.appendFile(getLogFilePath(), line, 'utf8');
  } catch (error) {
    console.error('No fue posible escribir el log del servicio:', error.message);
  }
}

module.exports = { writeServiceLog };
