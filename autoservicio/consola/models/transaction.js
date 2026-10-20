class TransactionModel{

    constructor( {IdAutorizacion,IdTransaccion,Valor,IdFormaPago,FormaPago,IdEstado,Estado,FechaTransaccion,SerialId,RespuestaPago}){
        this.IdAutorizacion = IdAutorizacion;
        this.IdTransaccion = IdTransaccion;
        this.Valor = Valor;
        this.IdFormaPago = IdFormaPago;
        this.FormaPago = FormaPago;
        this.IdEstado = IdEstado;
        this.Estado = Estado;
        this.FechaTransaccion = FechaTransaccion;
        this.SerialId = SerialId;
        this.RespuestaPago = RespuestaPago;
    }
};

class TransactionStatusModel{

    constructor(IdTransaccion,IdAutorizacion,IdEstado,Respuesta,SerialId){
        this.IdTransaccion = IdTransaccion;
        this.IdAutorizacion = IdAutorizacion;
        this.IdEstado = IdEstado;
        this.Respuesta = Respuesta;
        this.SerialId = SerialId;
    }
}

module.exports ={ TransactionModel,TransactionStatusModel};