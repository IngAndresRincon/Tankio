(function () {
  function getParam(name) {
    return new URLSearchParams(window.location.search).get(name);
  }

  function setText(id, value) {
    var el = document.getElementById(id);
    if (el) {
      el.textContent = value || '-';
      el.classList.toggle('empty', !value);
    }
  }

  function normalize(value) {
    return value === undefined || value === null || value === '' ? null : String(value);
  }

  function buildCustomer(data) {
    var name = [data.x_customer_name, data.x_customer_lastname].filter(Boolean).join(' ').trim();
    if (name) {
      return name;
    }
    if (data.x_business) {
      return data.x_business;
    }
    return null;
  }

  function buildStatus(data) {
    return normalize(data.x_transaction_state || data.x_response || data.x_respuesta) || null;
  }

  function buildCode(data) {
    return normalize(data.x_cod_response || data.x_cod_respuesta) || null;
  }

  function buildAmount(data) {
    var amount = normalize(data.x_amount);
    if (!amount) {
      return null;
    }
    return data.x_currency_code ? amount + ' ' + data.x_currency_code : amount;
  }

  function isApproved(code, status) {
    var value = String(code || status || '').toLowerCase();
    return ['1', 'approved', 'aprobada', 'aceptada', 'accepted'].includes(value);
  }

  function isRejected(code, status) {
    var value = String(code || status || '').toLowerCase();
    return ['2', 'rejected', 'rechazada', 'declined', 'declinada', 'fallida', 'failed'].includes(value);
  }

  function paintStatus(code, status) {
    var pill = document.getElementById('status-pill');
    if (!pill) {
      return;
    }

    pill.className = 'pill';
    if (isApproved(code, status)) {
      pill.classList.add('success');
      pill.textContent = 'Aprobado';
      return;
    }

    if (isRejected(code, status)) {
      pill.classList.add('danger');
      pill.textContent = 'Rechazado';
      return;
    }

    pill.textContent = status || 'Pendiente';
  }

  function paintBanner(code, status) {
    var banner = document.getElementById('result-banner');
    if (!banner) {
      return;
    }

    banner.className = 'result-banner';
    if (isApproved(code, status)) {
      banner.classList.add('success');
      banner.textContent = 'Pago aprobado correctamente. Puedes usar este comprobante como soporte.';
      return;
    }

    if (isRejected(code, status)) {
      banner.classList.add('danger');
      banner.textContent = 'Pago rechazado. Revisa los datos del medio de pago o intenta nuevamente.';
      return;
    }

    banner.textContent = 'La transacción aún no tiene un resultado final.';
  }

  function renderPayment(data) {
    var tx = data || {};
    var refPayco = normalize(tx.x_ref_payco || getParam('ref_payco') || getParam('x_ref_payco'));
    var invoice = normalize(tx.x_id_invoice || tx.x_id_factura);
    var status = buildStatus(tx);
    var code = buildCode(tx);
    var amount = buildAmount(tx);
    var currency = normalize(tx.x_currency_code);
    var date = normalize(tx.x_transaction_date || tx.x_fecha_transaccion);
    var customer = buildCustomer(tx);
    var method = normalize(tx.x_payment_method);
    var reason = normalize(tx.x_response_reason_text);

    setText('ref', refPayco);
    setText('ref-pill', refPayco ? 'Ref: ' + refPayco : 'Ref: -');
    setText('invoice', invoice);
    setText('status', status);
    setText('code', code);
    setText('amount', amount);
    setText('currency', currency);
    setText('date', date);
    setText('customer', customer);
    setText('method', method);
    setText('reason', reason);

    paintStatus(code, status);
    paintBanner(code, status);

    var subtitle = document.getElementById('subtitle');
    if (subtitle) {
      subtitle.textContent = isApproved(code, status)
        ? 'Pago aprobado correctamente'
        : isRejected(code, status)
          ? 'Pago rechazado'
          : 'Respuesta de ePayco';
    }
  }

  async function loadPaymentInfo(refPayco) {
    var url = '/api/sandbox.tankio/v1/payment-gateway/webhook/epayco/validation/' + encodeURIComponent(refPayco);
    var response = await fetch(url, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error('No se pudo consultar el pago');
    }

    return response.json();
  }

  document.addEventListener('DOMContentLoaded', function () {
    var refPayco = getParam('ref_payco') || getParam('x_ref_payco');

    renderPayment({ x_ref_payco: refPayco });

    if (!refPayco) {
      return;
    }

    loadPaymentInfo(refPayco)
      .then(function (response) {
        var data = response && response.data ? response.data : response;
        renderPayment(data);
      })
      .catch(function () {
        setText('status', 'Error consultando la transacción');
        var pill = document.getElementById('status-pill');
        if (pill) {
          pill.className = 'pill danger';
          pill.textContent = 'Error';
        }
      });
  });
}());
