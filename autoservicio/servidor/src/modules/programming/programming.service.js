const programmingRepository = require("./programming.repository");

exports.createProgramming = async (data) => {
  const positionStatus = await programmingRepository.findPositionStatus(data);
  if (!positionStatus) {
    const error = new Error(
      "No se encuentra información de la posición de la manguera",
    );
    error.statusCode = 404;
    error.code = "POSITION_NOT_FOUND";
    throw error;
  }

  if (positionStatus.fk_id_tipo_estado !== 8) {
    const error = new Error(
      "La manguera de combustible, se encuentra levantada. No es posible realizar la programación de combustible",
    );
    error.statusCode = 409;
    error.code = "HOSE_NOT_AVAILABLE";
    throw error;
  }

  const validation = await programmingRepository.findUserProgramming(data);
  if (!validation) {
    //Crear nueva programación
    const programming = await programmingRepository.createProgramming(data);
    if (!programming) {
      const error = new Error(
        "No se existe el serial de la pantalla en el sistema",
      );
      error.statusCode = 404;
      error.code = "STATION_NOT_FOUND";
      throw error;
    }

    return programming;
  }

  // Validar si la programación es antigua, no tiene valor abonado y no se ha autorizado
  if (validation.valor_abonado === 0 && !validation.autorizado) {
    //Actualizar programación con los nuevos datos
    const programming = await programmingRepository.updateProgrammnig(
      data,
      validation.id,
    );
    if (!programming) {
      const error = new Error(
        "No se existe el serial de la pantalla en el sistema",
      );
      error.statusCode = 404;
      error.code = "STATION_NOT_FOUND";
      throw error;
    }
    return programming;
  }

  //Validar si la programación tiene valor abonado, pero no se ha creado la autorizacion
  if (validation.valor_abonado > 0 && !validation.autorizado) {
    return validation;
  }

  //Validar si la programación ya tiene el pago completo, y ya se creó la autorizacion
  if (
    validation.valor_abonado === validation.valor_dinero &&
    validation.idautorizacion
  ) {
    return validation;
  }

  return null;
};

exports.findPendingProgrammingByUserId = async (userId, screenId) => {
  let statuscode = 204; // Responde solo cuando no hay transacción pendientes con valor abonado
  let prepaidprogramming =
    await programmingRepository.findPendingProgrammingByUserId(
      userId,
      screenId,
    );
  statuscode = !prepaidprogramming ? statuscode : 200;

  if (prepaidprogramming) {
    const prog = {
      positionId: prepaidprogramming.fk_id_posicion,
      screenId: prepaidprogramming.fk_id_pantalla,
      userId: prepaidprogramming.fk_id_cliente,
    };
    const positionStatus = await programmingRepository.findPositionStatus(prog);
    if (!positionStatus) {
      const error = new Error(
        "No se encuentra información de la posición de la manguera",
      );
      error.statusCode = 404;
      error.code = "POSITION_NOT_FOUND";
      throw error;
    }

    if (positionStatus.fk_id_tipo_estado !== 8) {
      const error = new Error(
        "La manguera de combustible, se encuentra levantada. No es posible realizar la programación de combustible",
      );
      error.statusCode = 409;
      error.code = "HOSE_NOT_AVAILABLE";
      throw error;
    }

    // if (prepaidprogramming.autorizado) {
    //   const auth = await programmingRepository.findAuthorizationByProgramming(
    //     prepaidprogramming.id,
    //   );
    //   if (auth) {
    //     prepaidprogramming =
    //       await programmingRepository.releasePendingProgramming(
    //         prepaidprogramming.id,
    //       );
    //   }
    // }
  }

  // prepaidprogramming =  await programmingRepository.findPendingProgrammingByUserId(userId, true);
  // statuscode = !prepaidprogramming?statuscode : 200;

  return { statuscode, prepaidprogramming };
};

exports.authorizeprogramming = async (programmingId) => {
  const programming =
    await programmingRepository.findProgrammingById(programmingId);

  if (!programming) {
    const error = new Error("No existe la programación");
    error.statusCode = 404;
    error.code = "PROGRAMMING_NOT_FOUND";
    throw error;
  }

  if (!programming.autorizado) {
    const authorized =
      await programmingRepository.authorizeprogramming(programmingId);
    return authorized;
  } else {
    const auth = await programmingRepository.findAuthorizationByProgramming(programming.id);
    if (auth) {
      return await programmingRepository.releasePendingProgramming(programming.id);
    }
  }
  return null;
};

exports.createpayment = async (data) => {
  const pendingPayment = await programmingRepository.findPendingPayment(data);

  if (!pendingPayment) {
    //Crear pago
    return await createpayment({ data: data });
  }

  if (pendingPayment.fk_id_estado_transaccion_pago === 4) {
    //Aún hay un pago en proceso, cancelar y crear uno nuevo
    const canceled = await programmingRepository.cancelPayment(pendingPayment);
    if (!canceled) {
      const error = new Error(
        "Error cancelando transacción de pago sin procesar",
      );
      error.statusCode = 409;
      error.code = "PAYMENT_CANCELLATION_FAILED";
      throw error;
    }
    return await createpayment({ data: data });
  }
  if (pendingPayment.fk_id_estado_transaccion_pago === 1) {
    //Transacción sin enviar
    const canceled = await programmingRepository.cancelPayment(pendingPayment);
    if (!canceled) {
      const error = new Error(
        "Error cancelando transacción de pago sin procesar",
      );
      error.statusCode = 409;
      error.code = "PAYMENT_CANCELLATION_FAILED";
      throw error;
    }
    return await createpayment({ data: data });
  }
  return pendingPayment;
};

async function createpayment({ data }) {
  const payment = await programmingRepository.createpayment(data);
  if (!payment) {
    const error = new Error("Error registrando pago");
    error.statusCode = 500;
    error.code = "PAYMENT_CREATION_FAILED";
    throw error;
  }
  return payment;
}

exports.cancelpayment = async (id) => {
  const pendingPayment =
    await programmingRepository.findTransactionPaymentById(id);
  if (!pendingPayment) {
    const error = new Error("No se encuentra información de la transacción");
    error.statusCode = 404;
    error.code = "PAYMENT_TRANSACTION_NOT_FOUND";
    throw error;
  }

  const result = await programmingRepository.cancelPayment(pendingPayment);

  return { pendingPayment, result };
};

exports.lastSaleByTerminalId = async (id) => {
  return await programmingRepository.lastSaleByTerminalId(id);
};

exports.lastsalebyprogramming = async (id) => {
  return await programmingRepository.lastsalebyprogramming(id);
};
exports.availableproducts = async (id) => {
  return await programmingRepository.availableproducts(id);
};

exports.changeproduct = async(productId, programmingId)=>{
  const programming = await programmingRepository.findProgrammingById(programmingId);
  if(!programming){
    const error = new Error("No existe la programación");
    error.statusCode = 404;
    error.code = "PROGRAMMING_NOT_FOUND";
    throw error;
  }

  const hose = await programmingRepository.findAvailableHose(
    programming.fk_id_posicion,productId);
    
  if(!hose){
    const error = new Error("Manguera disponible, no encontrada.");
    error.statusCode = 404;
    error.code = "HOSE_NOT_FOUND";
    throw error;
  }

  const resultChange  = await programmingRepository.changeProduct(programming,hose);
  if(resultChange){
    const auth = await programmingRepository.findAuthorizationByProgramming(programmingId);
    if (auth) {
      await programmingRepository.releasePendingProgramming(programmingId);
    }
  }
  return {resultChange, hose };
}
