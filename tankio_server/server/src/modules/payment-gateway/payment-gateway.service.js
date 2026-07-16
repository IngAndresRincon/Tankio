const paymentGatewayRepository = require('./payment-gateway.repository');

exports.receiveEpaycoWebhook = async (payload, headers) => {
  return paymentGatewayRepository.saveWebhookEventEpayco('epayco', payload, headers);
};

exports.receiveWompiWebhook = async (payload, headers) => {
  return paymentGatewayRepository.saveWebhookEventWompi('wompi', payload, headers);
};


exports.registerpaymentgateway = async (payload) => {
  return paymentGatewayRepository.registerpaymentgateway( payload);
};

exports.getPaymentInfoByReference = async (reference) => {
  return paymentGatewayRepository.getPaymentInfoByReference(reference);
};


