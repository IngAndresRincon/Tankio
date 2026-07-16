const paymentRepository = require("./payment.repository");
const { env } = require("../../config/env");

exports.historypaymentrequest = async ()=>{
  return await paymentRepository.historypaymentrequest();
}

