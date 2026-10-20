const assert = require('node:assert/strict');
const saleController = require('../src/modules/sale/sale.controller');

module.exports = async function testSaleStop() {
  let statusCode = null;
  let payload = null;
  let nextCalled = false;

  const res = {
    status(code) {
      statusCode = code;
      return this;
    },
    json(body) {
      payload = body;
      return this;
    }
  };

  await saleController.stop({}, res, () => {
    nextCalled = true;
  });

  assert.equal(nextCalled, false);
  assert.equal(statusCode, 501);
  assert.deepEqual(payload, {
    message: 'Stop operation is not implemented yet'
  });
};
