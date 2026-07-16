

class InvoiceAuthentication{
    constructor(username,password,stationId,terminalId){
        this.username= username;
        this.password = password;
        this.stationId = stationId;
        this.terminalId = terminalId;
    }
}



module.exports = {InvoiceAuthentication}
