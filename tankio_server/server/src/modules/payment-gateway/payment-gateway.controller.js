const fs = require('fs');
const path = require('path');
const https = require('https');
const paymentGatewayService = require('./payment-gateway.service');
const { createHttpError } = require('../../common/http-error');

function fetchEpaycoReference(refPayco) {
  const url = `https://secure.epayco.co/validation/v1/reference/${encodeURIComponent(refPayco)}`;

  return new Promise((resolve, reject) => {
    const request = https.get(
      url,
      {
        headers: {
          Accept: 'application/json',
        },
      },
      (response) => {
        let rawBody = '';

        response.on('data', (chunk) => {
          rawBody += chunk;
        });

        response.on('end', () => {
          let parsedBody = rawBody;

          try {
            parsedBody = rawBody ? JSON.parse(rawBody) : null;
          } catch (error) {
            // Keep the raw body if ePayco returns non-JSON content.
          }

          resolve({
            statusCode: response.statusCode || 200,
            body: parsedBody,
          });
        });
      }
    );

    request.on('error', reject);
    request.setTimeout(15000, () => {
      request.destroy(new Error('ePayco validation request timed out'));
    });
  });
}

exports.receiveEpaycoWebhook = async (req, res, next) => {
  try {

    console.log(`Respuesta evento epayco: ${JSON.stringify(req.body)}`);
    const result = await paymentGatewayService.receiveEpaycoWebhook(req.body, req.headers);

    return res.status(200).json({
      isError: false,
      message: 'Epayco webhook processed successfully',
      content: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.receiveWompiWebhook = async (req, res, next) => {
  try {
    const result = await paymentGatewayService.receiveWompiWebhook(req.body, req.headers);

    return res.status(200).json({
      isError: false,
      message: 'Wompi webhook processed successfully',
      content: result,
    });
  } catch (error) {
    return next(error);
  }
};

exports.getEpaycoReferenceValidation = async (req, res, next) => {
  try {
    const { ref } = req.params;

    const response = await fetch(
      `https://secure.epayco.co/validation/v1/reference/${ref}`
    );

    const data = await response.json();
    return res.status(response.status).json(data);
  } catch (error) {
    return next(error);
  }
};
exports.getWompiReferenceValidation = async (req, res, next) => {
  try {
    const { id, env } = req.query;

    if (!id) {
      throw createHttpError(400, '', 'Transaction id is required');
    }

    const wompiBaseUrl = getWompiBaseUrl(env);
    const wompiResponse = await fetch(
      `${wompiBaseUrl}/v1/transactions/${encodeURIComponent(id)}`,
      {
        headers: {
          Accept: 'application/json',
        },
      }
    );

    const data = await wompiResponse.json();

    if (!wompiResponse.ok) {
      throw createHttpError(
        wompiResponse.status,
        '',
        'Unable to retrieve Wompi transaction'
      );
    }

    const transaction = normalizeWompiTransaction(data);
    const html = renderWompiResponseHtml(transaction, env);

    return res.status(200).type('html').send(html);
  } catch (error) {
    const statusCode = error.statusCode || 500;
    const html = renderWompiResponseHtml(
      {
        status: 'ERROR',
        status_message: error.message || 'Unable to retrieve Wompi transaction',
        reference: '-',
        id: '-',
        finalized_at: null,
        created_at: null,
        amount_in_cents: null,
        currency: '-',
        customer_data: {},
        customer_email: '-',
        payment_method_type: '-',
        merchant: {},
      },
      req.query.env
    );

    return res.status(statusCode).type('html').send(html);
  }
};



exports.registerpaymentgateway = async (req, res, next) => {
  try {

    const body = req.body;

    const result = await paymentGatewayService.registerpaymentgateway(body);

    return res.status(201).json({
      message: "Payment gateway created successfully",
      data: result,
    });

  
  } catch (error) {
    return next(error);
  }
};

function getWompiBaseUrl(env) {
  const normalized = String(env || 'prod').toLowerCase();

  if (['sandbox', 'test', 'staging', 'stage'].includes(normalized)) {
    return 'https://sandbox.wompi.co';
  }

  return 'https://production.wompi.co';
}

function normalizeWompiTransaction(response) {
  if (!response) {
    return {};
  }

  if (response.data && response.data.transaction) {
    return response.data.transaction;
  }

  return response.data || response;
}

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (char) => {
    switch (char) {
      case '&':
        return '&amp;';
      case '<':
        return '&lt;';
      case '>':
        return '&gt;';
      case '"':
        return '&quot;';
      case "'":
        return '&#39;';
      default:
        return char;
    }
  });
}

function formatMoney(amountInCents, currency) {
  const amount = Number(amountInCents);

  if (!Number.isFinite(amount)) {
    return '-';
  }

  const formatted = new Intl.NumberFormat('es-CO', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(amount / 100);

  return currency ? `${formatted} ${currency}` : formatted;
}

function formatDate(value) {
  if (!value) {
    return '-';
  }

  const date = new Date(value);

  if (Number.isNaN(date.getTime())) {
    return escapeHtml(value);
  }

  return new Intl.DateTimeFormat('es-CO', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(date);
}

function getWompiStatusInfo(status, message) {
  const normalized = String(status || '').toUpperCase();

  if (normalized === 'APPROVED') {
    return {
      label: 'Aprobado',
      className: 'success',
      subtitle: 'Pago aprobado correctamente',
      banner: 'Pago aprobado correctamente. Puedes usar este comprobante como soporte.',
    };
  }

  if (['DECLINED', 'VOIDED', 'ERROR', 'FAILED'].includes(normalized)) {
    return {
      label: 'Rechazado',
      className: 'danger',
      subtitle: 'Pago rechazado',
      banner: message || 'Pago rechazado. Revisa los datos del medio de pago o intenta nuevamente.',
    };
  }

  return {
    label: normalized ? normalized : 'Pendiente',
    className: 'warning',
    subtitle: 'Transaccion en proceso',
    banner: message || 'La transaccion aun no tiene un resultado final.',
  };
}

function renderWompiResponseHtml(transaction, env) {
  const templatePath = path.resolve(
    __dirname,
    '../../../public/wompi-response.html'
  );

  const template = fs.readFileSync(templatePath, 'utf8');
  const statusInfo = getWompiStatusInfo(transaction.status, transaction.status_message);
  const customerName = transaction.customer_data?.full_name || transaction.customer_email || '-';
  const paymentMethod = transaction.payment_method_type || transaction.payment_method?.type || '-';
  const merchantName = transaction.merchant?.legal_name || transaction.merchant?.name || '-';
  const statusMessage = transaction.status_message || '-';

  const replacements = {
    '{{status_class}}': statusInfo.className,
    '{{status_label}}': escapeHtml(statusInfo.label),
    '{{subtitle}}': escapeHtml(statusInfo.subtitle),
    '{{banner}}': escapeHtml(statusInfo.banner),
    '{{reference}}': escapeHtml(transaction.reference || '-'),
    '{{transaction_id}}': escapeHtml(transaction.id || '-'),
    '{{date}}': escapeHtml(formatDate(transaction.finalized_at || transaction.created_at)),
    '{{amount}}': escapeHtml(formatMoney(transaction.amount_in_cents, transaction.currency)),
    '{{currency}}': escapeHtml(transaction.currency || '-'),
    '{{customer_name}}': escapeHtml(customerName),
    '{{customer_email}}': escapeHtml(transaction.customer_email || '-'),
    '{{payment_method}}': escapeHtml(paymentMethod),
    '{{merchant_name}}': escapeHtml(merchantName),
    '{{status_message}}': escapeHtml(statusMessage),
    '{{environment}}': escapeHtml(String(env || 'prod').toUpperCase()),
  };

  return Object.entries(replacements).reduce(
    (html, [placeholder, value]) => html.split(placeholder).join(value),
    template
  );
}
