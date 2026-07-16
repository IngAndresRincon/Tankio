const assert = require('node:assert/strict');
const http = require('node:http');
const path = require('node:path');

function mockModule(modulePath, exports) {
  const resolved = require.resolve(modulePath);
  require.cache[resolved] = {
    id: resolved,
    filename: resolved,
    loaded: true,
    exports
  };
}

function clearModule(modulePath) {
  try {
    const resolved = require.resolve(modulePath);
    delete require.cache[resolved];
  } catch (error) {
    if (error.code !== 'MODULE_NOT_FOUND') {
      throw error;
    }
  }
}

function request(port, method, urlPath, body) {
  return new Promise((resolve, reject) => {
    const payload = body ? JSON.stringify(body) : null;
    const req = http.request(
      {
        hostname: '127.0.0.1',
        port,
        path: urlPath,
        method,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': '123456',
          ...(payload ? { 'Content-Length': Buffer.byteLength(payload) } : {})
        }
      },
      (res) => {
        let raw = '';
        res.setEncoding('utf8');
        res.on('data', (chunk) => {
          raw += chunk;
        });
        res.on('end', () => {
          let parsed = raw;
          try {
            parsed = raw ? JSON.parse(raw) : null;
          } catch (error) {
            // Keep raw response when it isn't JSON.
          }
          resolve({ statusCode: res.statusCode, body: parsed });
        });
      }
    );

    req.on('error', reject);

    if (payload) {
      req.write(payload);
    }

    req.end();
  });
}

module.exports = async function testIntegrationRoutes() {
  const root = path.resolve(__dirname, '..');

  const pathsToClear = [
    'src/routes/mapping.routes.js',
    'src/routes/sale.routes.js',
    'src/routes/totals.routes.js',
    'src/routes/preset.routes.js',
    'src/controllers/mapping.controller.js',
    'src/controllers/sale.controller.js',
    'src/controllers/totals.controller.js',
    'src/controllers/preset.controller.js',
    'src/services/mapping.service.js',
    'src/services/sale.service.js',
    'src/services/totals.service.js',
    'src/services/preset.service.js',
    'src/repositories/mapping.repository.js',
    'src/repositories/sale.repository.js',
    'src/repositories/totals.repository.js',
    'src/repositories/preset.repository.js',
    'src/modules/mapping/mapping.routes.js',
    'src/modules/mapping/mapping.controller.js',
    'src/modules/mapping/mapping.service.js',
    'src/modules/mapping/mapping.repository.js',
    'src/modules/prices/prices.routes.js',
    'src/modules/prices/prices.controller.js',
    'src/modules/prices/prices.service.js',
    'src/modules/prices/prices.repository.js',
    'src/modules/preset/preset.routes.js',
    'src/modules/preset/preset.controller.js',
    'src/modules/preset/preset.service.js',
    'src/modules/preset/preset.repository.js',
    'src/modules/status/status.routes.js',
    'src/modules/status/status.controller.js',
    'src/modules/status/status.service.js',
    'src/modules/status/status.repository.js',
    'src/modules/sale/sale.routes.js',
    'src/modules/sale/sale.controller.js',
    'src/modules/sale/sale.service.js',
    'src/modules/sale/sale.repository.js',
    'src/modules/totals/totals.routes.js',
    'src/modules/totals/totals.controller.js',
    'src/modules/totals/totals.service.js',
    'src/modules/totals/totals.repository.js',
    'src/modules/totals/totals.mapper.js'
  ];

  for (const relativePath of pathsToClear) {
    clearModule(path.join(root, relativePath));
  }

  const pricesServicePath = path.join(root, 'src/modules/prices/prices.service.js');
  const mappingServicePath = path.join(root, 'src/modules/mapping/mapping.service.js');
  const presetServicePath = path.join(root, 'src/modules/preset/preset.service.js');
  const statusServicePath = path.join(root, 'src/modules/status/status.service.js');
  const saleServicePath = path.join(root, 'src/modules/sale/sale.service.js');
  const totalsServicePath = path.join(root, 'src/modules/totals/totals.service.js');

  mockModule(mappingServicePath, {
    mapping: async () => ({
      model: 'MockModel',
      faces: [{ face: 'A', positions: [{ position: 1, face: 'A', hoses: [] }] }]
    })
  });

  mockModule(pricesServicePath, {
    prices: async () => ({ prices: [{ position: 1, hose: 1, price: 100 }] }),
    updateprices: async () => ({ updated: 1 })
  });

  mockModule(presetServicePath, {
    preset: async (preset) => ({
      presetid: 1,
      position: preset.position,
      hose: preset.hose,
      price: preset.price,
      value: preset.value,
      type: preset.type
    })
  });

  mockModule(statusServicePath, {
    status: async () => ({ model: 'MockModel', positions: [{ position: 1, face: 'A' }] }),
    statusbyposition: async (position) => ({ positions: [{ position, face: 'A' }] })
  });

  mockModule(saleServicePath, {
    bypreset: async (presetId) => ({ presetId, source: 'mocked' }),
    lastsalebyposition: async (position) => ({ position, source: 'mocked' })
  });

  mockModule(totalsServicePath, {
    totals: async () => ({ positions: [{ position: 1, face: 'A', hoses: [] }] })
  });

  const createApp = require('../src/config/app');
  const app = createApp();

  const server = await new Promise((resolve) => {
    const instance = app.listen(0, () => resolve(instance));
  });

  try {
    const port = server.address().port;

    const pricesGet = await request(port, 'GET', '/insepet-autoservice/api/v1/prices');
    assert.equal(pricesGet.statusCode, 200);
    assert.deepEqual(pricesGet.body.data, { prices: [{ position: 1, hose: 1, price: 100 }] });

    const pricesBadPost = await request(port, 'POST', '/insepet-autoservice/api/v1/prices', {});
    assert.equal(pricesBadPost.statusCode, 400);
    assert.match(pricesBadPost.body.message, /prices must be a non-empty array/i);

    const mappingGet = await request(port, 'GET', '/insepet-autoservice/api/v1/mapping');
    assert.equal(mappingGet.statusCode, 200);
    assert.deepEqual(mappingGet.body.data, {
      model: 'MockModel',
      faces: [{ face: 'A', positions: [{ position: 1, face: 'A', hoses: [] }] }]
    });

    const statusGet = await request(port, 'GET', '/insepet-autoservice/api/v1/status');
    assert.equal(statusGet.statusCode, 200);
    assert.deepEqual(statusGet.body.data, { model: 'MockModel', positions: [{ position: 1, face: 'A' }] });

    const statusByPosition = await request(port, 'GET', '/insepet-autoservice/api/v1/status/7');
    assert.equal(statusByPosition.statusCode, 200);
    assert.deepEqual(statusByPosition.body.data, { positions: [{ position: 7, face: 'A' }] });

    const saleByPreset = await request(port, 'GET', '/insepet-autoservice/api/v1/sale/by-preset/410');
    assert.equal(saleByPreset.statusCode, 200);
    assert.deepEqual(saleByPreset.body.data, { presetId: 410, source: 'mocked' });

    const presetPost = await request(port, 'POST', '/insepet-autoservice/api/v1/preset', {
      position: 1,
      hose: 1,
      price: 100,
      value: 50,
      type: 'FULL'
    });
    assert.equal(presetPost.statusCode, 201);
    assert.equal(presetPost.body.data.position, 1);
    assert.equal(presetPost.body.data.type, 'FULL');

    const totals = await request(port, 'GET', '/insepet-autoservice/api/v1/totals');
    assert.equal(totals.statusCode, 200);
    assert.deepEqual(totals.body.data, { positions: [{ position: 1, face: 'A', hoses: [] }] });
  } finally {
    await new Promise((resolve) => server.close(resolve));
  }
};
