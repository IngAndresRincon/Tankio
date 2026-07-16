const pool = require('../../database/pg');
const { createHttpError } = require('../../common/http-error');
const crypto = require('crypto');
async function getPaymentGatewayIdByCode(code) {
  const query = `
    SELECT id
    FROM public.payment_gateway
    WHERE code = $1 AND active = true
    LIMIT 1;
  `;

  const result = await pool.query(query, [code]);
  return result.rowCount > 0 ? result.rows[0].id : null;
}

async function getDefaultGroupIdByGatewayCode(code) {
  const query = `
    SELECT gpg.group_id
    FROM public.group_payment_gateway gpg
    INNER JOIN public.payment_gateway pg
      ON pg.id = gpg.payment_gateway_id
    WHERE pg.code = $1
      AND gpg.enabled = true
      AND pg.active = true
    ORDER BY gpg.is_default DESC, gpg.id ASC
    LIMIT 1;
  `;

  const result = await pool.query(query, [code]);
  return result.rowCount > 0 ? result.rows[0].group_id : null;
}

function safeJson(value, fallback) {
  return value === undefined || value === null ? fallback : value;
}

function toNumberOrNull(value) {
  if (value === undefined || value === null || value === '') {
    return null;
  }

  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function pad2(value) {
  return String(value).padStart(2, '0');
}

function formatReferenceTimestamp(date = new Date()) {
  const year = date.getFullYear();
  const month = pad2(date.getMonth() + 1);
  const day = pad2(date.getDate());
  const hours = pad2(date.getHours());
  const minutes = pad2(date.getMinutes());
  const seconds = pad2(date.getSeconds());

  return `${year}${month}${day}${hours}${minutes}${seconds}`;
}





function buildUUIDReference(reference){
  const uuid = crypto.randomUUID();
  return `${reference}-${uuid}`
}

async function buildWompiSignature(ref,payload){
  
  const paymentGroup = await getPaymentGatewayGroup(payload);
  if(!paymentGroup){
    const error = new Error('Payment gateway not configured for this request');
    error.statusCode = 500;
    error.code = '';
    throw error;
  }

  const amountPayment = parseInt(payload.amount) *100;

  const signature =`${ref}${amountPayment}${payload.currency}${paymentGroup.credentials.integridad}`;
  
  //Ejemplo
  const encondedText = new TextEncoder().encode(signature);
  const hashBuffer = await crypto.subtle.digest("SHA-256", encondedText);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map((b) => b.toString(16).padStart(2, "0")).join(""); 
  return hashHex;
}

async function getPaymentGatewayGroup(payload){
  const query = `SELECT * FROM public.group_payment_gateway WHERE group_id = $1 AND payment_gateway_id = $2 AND enabled=$3 LIMIT 1;`;
  const result = await pool.query(query,[payload.group_id,payload.payment_gateway_id,true]);
  return result.rowCount>0? result.rows[0] : null;
}

function safeParseJson(value) {
  if (!value) {
    return {};
  }

  if (typeof value === 'object') {
    return value;
  }

  try {
    return JSON.parse(value);
  } catch (error) {
    return {};
  }
}

function normalizePaymentPayload(row) {
  if (!row) {
    return null;
  }

  const payload = safeParseJson(row.raw_payload);
  const request = row.payment_request_uuid ? {
    uuid: row.payment_request_uuid,
    group_id: row.group_id,
    station_id: row.station_id,
    user_id: row.user_id,
    payment_gateway_id: row.payment_gateway_id,
    request_reference: row.request_reference,
    invoice: row.invoice,
    request_type: row.request_type,
    request_amount: row.request_amount,
    request_currency: row.request_currency,
    description: row.description,
    payment_gateway_code: row.payment_gateway_code,
    payment_gateway_name: row.payment_gateway_name,
  } : {};

  return {
    ...payload,
    ...request,
    payment_request_uuid: row.payment_request_uuid,
    gateway_event_id: row.gateway_event_id,
    gateway_transaction_id: row.gateway_transaction_id,
    gateway_reference: row.gateway_reference,
    event_name: row.event_name,
    transaction_status: row.transaction_status,
    transaction_status_code: row.transaction_status_code,
    amount: row.amount,
    currency: row.currency,
    customer_email: row.customer_email,
    customer_name: row.customer_name,
    environment: row.environment,
    signature_checksum: row.signature_checksum,
    received_at: row.received_at,
    updated_at: row.updated_at,
    x_ref_payco: row.gateway_reference || payload.x_ref_payco || payload.ref_payco || null,
    x_id_invoice: row.invoice || payload.x_id_invoice || payload.x_id_factura || null,
    x_id_factura: row.invoice || payload.x_id_factura || payload.x_id_invoice || null,
    x_transaction_id: row.gateway_transaction_id || payload.x_transaction_id || null,
    x_transaction_state: row.transaction_status || payload.x_transaction_state || payload.x_respuesta || payload.x_response || null,
    x_respuesta: payload.x_respuesta || row.transaction_status || null,
    x_response: payload.x_response || row.transaction_status || null,
    x_cod_response: row.transaction_status_code || payload.x_cod_response || payload.x_cod_respuesta || null,
    x_cod_respuesta: row.transaction_status_code || payload.x_cod_respuesta || payload.x_cod_response || null,
    x_response_reason_text: payload.x_response_reason_text || null,
    x_amount: row.amount || payload.x_amount || row.request_amount || null,
    x_currency_code: row.currency || payload.x_currency_code || row.request_currency || null,
    x_payment_method: payload.x_payment_method || null,
    x_customer_email: row.customer_email || payload.x_customer_email || null,
    x_customer_name: row.customer_name || payload.x_customer_name || null,
    x_customer_lastname: payload.x_customer_lastname || null,
    x_business: payload.x_business || null,
    x_test_request: payload.x_test_request || null,
    source: 'database',
  };
}



function mapWompiTransactionStatus(status) {
  const normalizedStatus = String(status || '').toUpperCase();

  if (normalizedStatus === 'APPROVED') {
    return {
      requestStatusId: 3,
      requestStatus: 'approved',
      processStatus: 'processed',
      markProcessedAt: true,
      createBalanceMovement: true,
    };
  }

  if (normalizedStatus === 'PENDING' || normalizedStatus === 'IN_PROGRESS') {
    return {
      requestStatusId: 1,
      requestStatus: 'pending',
      processStatus: 'received',
      markProcessedAt: false,
      createBalanceMovement: false,
    };
  }

  return {
    requestStatusId: 2,
    requestStatus: normalizedStatus ? normalizedStatus.toLowerCase() : 'declined',
    processStatus: 'processed',
    markProcessedAt: true,
    createBalanceMovement: false,
  };
}

async function getPaymentRequestByReference(reference) {
  const query = `
    SELECT *
    FROM public.payment_request
    WHERE request_reference = $1
    LIMIT 1;
  `;

  const result = await pool.query(query, [reference]);
  return result.rowCount > 0 ? result.rows[0] : null;
}




exports.saveWebhookEventEpayco = async (gatewayCode, payload, headers) => {
  const paymentGatewayId = await getPaymentGatewayIdByCode(gatewayCode);

  if (!paymentGatewayId) {
     const error = new Error('Payment gateway not configured for this request');
     error.statusCode = 500;
     error.code = '';
     throw error;
   }
 const paymentRequest = await getPaymentRequestByReference(payload.x_extra2);
  if (!paymentRequest) {
    throw createHttpError(404, '', 'Payment request not found');
  }

  payload.x_extra3 = paymentRequest.uuid;

  const registerWebhook = await saveResponseWebhookEpayco(payload,headers);
  if(!registerWebhook){
      const error = new Error('Webhook event could not be stored');
      error.statusCode = 500;
      error.code = '';
      throw error;
  }



  const normalizedPayloadPayment = {
    status: payload.x_response || payload.x_respuesta || 'unknown',
    statusid: payload.x_cod_transaction_state === '1'? 3 : 4,
    refuuid :  payload.x_extra2,
    email : payload.x_customer_address || payload.x_customer_email || '-',
    name :  payload.x_customer_name || payload.x_customer_lastname || '-',
    payment_method : payload.x_payment_method || null,
    gateway_response_payload : payload
  };



  const _paymentReq = await updatePaymentRequest(normalizedPayloadPayment);
  if(!_paymentReq){
      const error = new Error('Payment request could not be updated');
      error.statusCode = 500;
      error.code = '';
      throw error;
  }

  if(normalizedPayloadPayment.statusid === 4) // Pago rechazado
  {
    return registerWebhook;
  }

  const existMovement = await findBalanceMovement(_paymentReq,1) // 1 es el tipo de movimiento que es recarga
  if(existMovement){
    return registerWebhook;
  }

  const isMoveBalance = await  createBalanceMovementRecord(_paymentReq);

  if(!isMoveBalance){
    const error = new Error('Balance movement could not be created');
    error.statusCode = 500;
    error.code = '';
    throw error;
  }

  return registerWebhook;
 
};


exports.saveWebhookEventWompi = async (gatewayCode, payload, headers) =>{
  const paymentGatewayId = await getPaymentGatewayIdByCode(gatewayCode);

  if (!paymentGatewayId) {
    throw createHttpError(500, '', 'Payment gateway not configured for this request');
  }

  const paymentRequest = await getPaymentRequestByReference(payload.data.transaction.reference);

  if (!paymentRequest) {
    throw createHttpError(404, '', 'Payment request not found');
  }

  const webhookEvent = await saveResponseWebhookWompi(
    payload,
    headers,
    paymentRequest
  );

  if (!webhookEvent) {
    throw createHttpError(500, '', 'Webhook event could not be stored');
  }


  const normalizedPayloadPayment = {
    status: payload.data.transaction.status,
    statusid: payload.data.transaction.status.toLowerCase() == 'DECLINED'?2:3,
    refuuid : payload.data.transaction.reference,
    email : payload.data.transaction.customer_email,
    name :  payload.data.transaction.customer_data.full_name,
    payment_method : JSON.stringify(payload.data.transaction.payment_method),
    gateway_response_payload : payload
  };
    

  const isUpdatePayment = await updatePaymentRequest(normalizedPayloadPayment);

   if(!isUpdatePayment){
      const error = new Error('Payment request could not be updated');
      error.statusCode = 500;
      error.code = '';
      throw error;
  }

  if(normalizedPayloadPayment.statusid === 2) // Pago rechazado
  {
    return webhookEvent
  }

  const isMoveBalance = await  createBalanceMovementRecord(isUpdatePayment);

   if(!isMoveBalance){
    const error = new Error('Balance movement could not be created');
    error.statusCode = 500;
    error.code = '';
    throw error;
  }

  return webhookEvent;
}



async function saveResponseWebhookEpayco(payload,headers){
    const query = `
    INSERT INTO public.payment_webhook_event (
      payment_request_uuid,
      gateway_event_id,
      gateway_transaction_id,
      gateway_reference,
      event_name,
      transaction_status,
      transaction_status_code,
      amount,
      currency,
      customer_email,
      customer_name,
      environment,
      signature_checksum,
      raw_payload,
      request_headers,
      process_status,
      received_at,
      updated_at
    )
    VALUES (
      $1,
      $2,
      $3,      
      $4,
      $5,
      $6,
      $7,
      $8,
      $9,
      $10,
      $11,
      $12,
      $13,
      $14::jsonb,
      $15::jsonb,
      'received',
      now(),
      now()
    )
    RETURNING *;`;

  const values = [
    payload.x_extra3 ,
    payload.x_cust_id_cliente,
    payload.x_transaction_id,
    payload.x_ref_payco,
    'webhook.received',
    payload.x_transaction_state,
    payload.x_cod_transaction_state,
    payload.x_amount,
    payload.x_currency_code,
    payload.x_customer_email,
    payload.x_customer_name,
    payload.x_test_request,
    payload.x_signature,
    JSON.stringify(payload?? {}),
    JSON.stringify(headers ?? {}),
  ];
  
  const result = await pool.query(query, values);
  return result.rowCount > 0 ? result.rows[0] : null;
}


async function saveResponseWebhookWompi(payload, headers, transaction) {

  const _amount = parseInt(payload.data.transaction.amount_in_cents) /100;

  const query = `
  INSERT INTO public.payment_webhook_event (
      payment_request_uuid,
      gateway_event_id,
      gateway_transaction_id,
      gateway_reference,
      event_name,
      transaction_status,
      transaction_status_code,
      amount,
      currency,
      customer_email,
      customer_name,
      environment,
      signature_checksum,
      signature_properties,
      raw_payload,
      request_headers,
      process_status,
      received_at,
      updated_at
    )
    VALUES (
      $1,
      $2,
      $3,      
      $4,
      $5,
      $6,
      $7,
      $8,
      $9,
      $10,
      $11,
      $12,
      $13,
      $14::jsonb,
      $15::jsonb,
      $16::jsonb,
      'received',
      now(),
      now()
    )
    RETURNING *;`;


  const values = [
    transaction.uuid || null, //payment_request_uuid
    payload.data.transaction.id || null, // gateway_event_id
    payload.data.transaction.id || null, // gateway_transaction_id
    payload.data.reference, //gateway_reference
    payload.event || null, //event_name
    payload.data.transaction.status, //transaction_status
    0, //transaction_status_code
    _amount, //amount
    payload.data.transaction.currency , //currency
    payload.data.transaction.customer_email  , //customer_email
    payload.data.transaction.customer_data.full_name, //customer_name
    payload.environment , //environment
    payload.signature.checksum , //signature_checksum
    payload.signature, //signature_properties
    payload,//raw_payload
    headers, //request_headers
  ];

  const result = await pool.query(query, values);
  return result.rowCount > 0 ? result.rows[0] : null;
}


async function updatePaymentRequest(normalizePayload = {}) {
  const query = `
    UPDATE public.payment_request
    SET
      request_status_id = $1,
      payment_method_type = COALESCE($2, payment_method_type),
      gateway_response_payload = COALESCE($3::jsonb, gateway_response_payload),
      processed_at =now(),
      updated_at = now()
    WHERE request_reference = $4
    RETURNING *;
  `;

  const result = await pool.query(query,[
    normalizePayload.statusid,
    normalizePayload.payment_method || null,
    normalizePayload.gateway_response_payload ? JSON.stringify(normalizePayload.gateway_response_payload) : null,
    normalizePayload.refuuid,
  ]);
  return result.rowCount>0 ? result.rows[0] : null;
}


async function findBalanceMovement(payment,idmov){
  const query = `SELECT id FROM public.balance_movement 
  WHERE user_id=$1 AND reference_uuid = $2 AND balance_movement_type_id = $3 LIMIT 1;`;
  const result = await pool.query(query,[payment.user_id,payment.uuid,idmov]);
  return result.rowCount > 0 ? result.rows[0] : null;
}

async function createBalanceMovementRecord(payment){

  let transactionFee = 0;

  transactionFee = await findTransactionFeeGroup(payment);
  const resultBalance = (payment.amount - transactionFee);
  const query = `INSERT INTO public.balance_movement (group_id,station_id,user_id,amount,balance_movement_type_id,reference_uuid) 
  VALUES($1,$2,$3,$4,$5,$6) RETURNING *;`;
  const result = await pool.query(query,
  [payment.group_id,payment.station_id,payment.user_id,resultBalance,1,payment.uuid]);
  return result.rowCount > 0 ? result.rows[0] : null;
}



async function findTransactionFeeGroup(payload){
  const query = `SELECT * FROM public.group_payment_gateway 
  WHERE group_id = $1 AND  payment_gateway_id = $2 LIMIT 1;`
  const result = await pool.query(query,[payload.group_id, payload.payment_gateway_id]);
  return result.rowCount>0? result.rows[0]['transaction_fee'] : 0;
}


exports.registerpaymentgateway = async (payload) =>{
  const validpayment = await getPendingPayment(payload);
  if(validpayment){
      const isRelease = await releasePaymentRequest(validpayment);
      if(!isRelease){
          const error = new Error('Pending payment request already exists');
          error.statusCode = 409;
          error.code = '';
          throw error;
      }
  }

  let currentInvoice = await getCurrentInvoice(payload);
  if(!currentInvoice){
    await registerInvoiceGroupId(payload);
    currentInvoice = await getCurrentInvoice(payload);
  }
  const payment = await registerNewPaymentGateway(payload,currentInvoice);

  await invoiceConsecutiveIncrease(currentInvoice,payload);
  return payment;
}

exports.getPaymentInfoByReference = async (reference) => {
  const query = `
    SELECT
      pwe.payment_request_uuid,
      pwe.gateway_event_id,
      pwe.gateway_transaction_id,
      pwe.gateway_reference,
      pwe.event_name,
      pwe.transaction_status,
      pwe.transaction_status_code,
      pwe.amount,
      pwe.currency,
      pwe.customer_email,
      pwe.customer_name,
      pwe.environment,
      pwe.signature_checksum,
      pwe.raw_payload,
      pwe.request_headers,
      pwe.process_status,
      pwe.received_at,
      pwe.updated_at,
      pr.group_id,
      pr.station_id,
      pr.user_id,
      pr.payment_gateway_id,
      pr.request_reference,
      pr.invoice,
      pr.request_type,
      pr.amount AS request_amount,
      pr.currency AS request_currency,
      pr.description,
      pg.code AS payment_gateway_code,
      pg.name AS payment_gateway_name
    FROM public.payment_webhook_event pwe
    LEFT JOIN public.payment_request pr
      ON pr.uuid = pwe.payment_request_uuid
    LEFT JOIN public.payment_gateway pg
      ON pg.id = pr.payment_gateway_id
    WHERE pwe.gateway_reference = $1
    ORDER BY pwe.received_at DESC
    LIMIT 1;
  `;

  const result = await pool.query(query, [reference]);
  return result.rowCount > 0 ? normalizePaymentPayload(result.rows[0]) : null;
};


async function getPendingPayment(payload){
  const query = `SELECT * FROM public.payment_request 
  WHERE group_id = $1 AND station_id =$2 AND user_id = $3 AND request_status_id = $4 LIMIT 1;`;
  const result = await pool.query(query,[payload.group_id,payload.station_id,payload.user_id,1]);
  return result.rows[0]||null;
}



async function releasePaymentRequest(payment){
  const descriptionMessage = "Usuario solicita de nuevo otra pago, esta transacción queda pendiente por respuesta";
  const query = `UPDATE public.payment_request 
  SET request_status_id =$1, description = $2
  WHERE id =$3 RETURNING *;`;
  const result = await pool.query(query,[4,descriptionMessage,payment.id]);
  return  result.rowCount>0? result.rows[0]:null;
}


async function registerNewPaymentGateway(payload,invoice){
  const requestReference = buildUUIDReference(payload.request_reference);
  let integritysignature = {signature:null};
  if(payload.payment_gateway_id === 2){
      integritysignature.signature = await  buildWompiSignature(requestReference,payload);
  }
  
  const transactionFee = await findTransactionFeeGroup(payload);
  payload.description = `Cobró por transacción valor de: ${transactionFee}`;

  const query = `INSERT INTO public.payment_request (group_id,station_id,user_id,payment_gateway_id,request_reference,invoice,request_type,amount,currency,description,metadata) 
  VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING *;`;
  const result = await pool.query(query,[
    payload.group_id,
    payload.station_id,
    payload.user_id,
    payload.payment_gateway_id,
    requestReference,
    `${invoice.prefix_code}-${invoice.last_invoice}`,
    payload.request_type,
    payload.amount,
    payload.currency,
    payload.description,
    integritysignature]);
  return result.rows[0] || null;

}

async function findTransactionFeeGroup(payload){
  const query = `SELECT transaction_fee FROM public.group_payment_gateway WHERE group_id = $1 AND payment_gateway_id = $2 LIMIT 1;`
  const result = await pool.query(query,[payload.group_id, payload.payment_gateway_id]);
  return result.rowCount>0? result.rows[0]['transaction_fee'] : 0;
}

async function getCurrentInvoice(payload){
  const query = `SELECT 
  pri.id as invoice_id,
  pri.station_id,
  pri.last_invoice,
  pri.registration_date,
  pri.update_at,
  g.id as group_id,
  g.owner_id,
  g.name,
  g.company_name,
  g.prefix_code
  FROM public.payment_request_invoice as pri
  INNER JOIN public.group as g
  ON pri.group_id = g.id
  WHERE group_id = $1 LIMIT 1;`;
  const result = await pool.query(query,[payload.group_id]);
  return result.rows[0] || null;
}

async function registerInvoiceGroupId(payload){
  const query = `INSERT INTO public.payment_request_invoice 
  (group_id) VALUES($1) RETURNING *;`;
  const result = await pool.query(query,[payload.group_id]);
  return result.rows[0] || null;
}

async function invoiceConsecutiveIncrease(invoice,payload){
  const query = `UPDATE public.payment_request_invoice 
  SET last_invoice = last_invoice + 1, station_id = $1, update_at = now()
  WHERE id = $2 RETURNING * ;`;
  const result = await pool.query(query,[payload.station_id,invoice.invoice_id ]);
  return result.rows[0] || null;
}
