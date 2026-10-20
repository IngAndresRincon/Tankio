const EventEmitter = require('events');

class Logger extends EventEmitter {
    log(mensaje) {
        this.emit('log', {logger:'Datafono', mensaje, fecha: new Date() });
    }

    error(mensaje){
        this.emit('error', {logger:'Datafono', mensaje, fecha: new Date() });
    }
}

const logger = new Logger();
logger.on('log', (data) => {
    console.log(`${data.logger}"${data.mensaje}" en ${data.fecha}`);
});


logger.on('error', (data) => {
    console.log(`${data.logger}"${data.mensaje}" en ${data.fecha}`);
});



module.exports = {logger};