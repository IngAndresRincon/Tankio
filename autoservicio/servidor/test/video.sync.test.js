const assert = require('node:assert/strict');
const { test } = require('node:test');
const fs = require('node:fs/promises');

// All database and filesystem operations are mocked; these tests do not change a device.
const queries = [];
let rows = [];
const poolPath = require.resolve('../src/database/pg');
require.cache[poolPath] = {
  id: poolPath, filename: poolPath, loaded: true,
  exports: { query: async (sql, params) => {
    queries.push({ sql, params });
    return { rows, rowCount: rows.length };
  } }
};
const envPath = require.resolve('../src/config/env');
require.cache[envPath] = { id: envPath, filename: envPath, loaded: true, exports: { env: {} } };

const repository = require('../src/modules/video/video.repository');
const service = require('../src/modules/video/video.service');
const controller = require('../src/modules/video/video.controller');
const configurationRepository = require('../src/modules/configuration/configuration.repository');
const configurationService = require('../src/modules/configuration/configuration.service');
const revision = 'a'.repeat(32);

function response() {
  return {
    statusCode: 200,
    status(code) { this.statusCode = code; return this; },
    set() { return this; },
    json(body) { this.body = body; return this; }
  };
}

function request() {
  return {
    query: { screenId: '2' }, station: { id: 2 }, protocol: 'http',
    get: () => 'localhost:40412',
    body: { screenId: 2, configurationId: 7, revision, version: 'promo.octubre.mp4:100:123' }
  };
}

function configuredVideo() {
  return { id: 7, nombre: 'promo.octubre.mp4', revision, sincronizar: true };
}

test('GET reads the requested screen without confirming synchronization', async (t) => {
  let screenId;
  t.mock.method(service, 'getVideoName', async (id) => { screenId = id; return configuredVideo(); });
  const confirm = t.mock.method(service, 'confirmSynchronization', async () => true);
  t.mock.method(fs, 'stat', async () => ({ isFile: () => true, size: 100, mtimeMs: 123 }));
  const res = response();
  await controller.defaultvideo(request(), res, (error) => { throw error; });
  assert.equal(screenId, 2);
  assert.equal(res.statusCode, 200);
  assert.equal(res.body.data.version, 'promo.octubre.mp4:100:123');
  assert.equal(res.body.data.revision, revision);
  assert.equal(res.body.data.pendingSynchronization, true);
  assert.equal(confirm.mock.callCount(), 0);
});

test('GET rejects a missing screen and a different authenticated screen', async () => {
  const req = request();
  delete req.query.screenId;
  let res = response();
  await controller.defaultvideo(req, res, (error) => { throw error; });
  assert.equal(res.statusCode, 400);
  req.query.screenId = '3';
  res = response();
  await controller.defaultvideo(req, res, (error) => { throw error; });
  assert.equal(res.statusCode, 403);
});

test('GET distinguishes absent configuration from a missing file', async (t) => {
  const getVideo = t.mock.method(service, 'getVideoName', async () => null);
  let res = response();
  await controller.defaultvideo(request(), res, (error) => { throw error; });
  assert.equal(res.statusCode, 404);
  const noConfiguration = res.body.message;
  getVideo.mock.mockImplementation(async () => configuredVideo());
  t.mock.method(fs, 'stat', async () => { throw Object.assign(new Error('missing'), { code: 'ENOENT' }); });
  res = response();
  await controller.defaultvideo(request(), res, (error) => { throw error; });
  assert.equal(res.statusCode, 404);
  assert.notEqual(res.body.message, noConfiguration);
});

test('confirmation passes screen, configuration and revision to the guarded update', async (t) => {
  t.mock.method(service, 'getVideoName', async () => configuredVideo());
  t.mock.method(fs, 'stat', async () => ({ isFile: () => true, size: 100, mtimeMs: 123 }));
  const confirm = t.mock.method(service, 'confirmSynchronization', async () => true);
  const res = response();
  await controller.confirm(request(), res, (error) => { throw error; });
  assert.equal(res.statusCode, 200);
  assert.deepEqual(confirm.mock.calls[0].arguments, [2, 7, revision]);
});

test('stale configuration cannot be confirmed', async (t) => {
  t.mock.method(service, 'getVideoName', async () => ({ ...configuredVideo(), revision: 'b'.repeat(32) }));
  const confirm = t.mock.method(service, 'confirmSynchronization', async () => true);
  const res = response();
  await controller.confirm(request(), res, (error) => { throw error; });
  assert.equal(res.statusCode, 409);
  assert.equal(confirm.mock.callCount(), 0);
});

test('changed file cannot be confirmed', async (t) => {
  t.mock.method(service, 'getVideoName', async () => configuredVideo());
  t.mock.method(fs, 'stat', async () => ({ isFile: () => true, size: 100, mtimeMs: 456 }));
  const confirm = t.mock.method(service, 'confirmSynchronization', async () => true);
  const res = response();
  await controller.confirm(request(), res, (error) => { throw error; });
  assert.equal(res.statusCode, 409);
  assert.equal(confirm.mock.callCount(), 0);
});

test('a concurrent configuration update returns conflict', async (t) => {
  t.mock.method(service, 'getVideoName', async () => configuredVideo());
  t.mock.method(fs, 'stat', async () => ({ isFile: () => true, size: 100, mtimeMs: 123 }));
  t.mock.method(service, 'confirmSynchronization', async () => false);
  const res = response();
  await controller.confirm(request(), res, (error) => { throw error; });
  assert.equal(res.statusCode, 409);
});

test('confirmation rejects invalid payloads and other screens', async () => {
  const req = request();
  req.body.screenId = 3;
  let res = response();
  await controller.confirm(req, res, (error) => { throw error; });
  assert.equal(res.statusCode, 403);
  req.body = {};
  res = response();
  await controller.confirm(req, res, (error) => { throw error; });
  assert.equal(res.statusCode, 400);
});

test('repository reads by screen without consuming synchronization flag', async () => {
  queries.length = 0;
  rows = [configuredVideo()];
  await service.getVideoName(2);
  assert.equal(queries.length, 1);
  assert.deepEqual(queries[0].params, [2]);
  assert.match(queries[0].sql, /fk_id_pantalla = \$1/);
  assert.doesNotMatch(queries[0].sql, /sincronizar\s*=/);
});

test('confirmation query is screen-scoped and revision-guarded', async () => {
  queries.length = 0;
  rows = [{ id: 7 }];
  assert.equal(await repository.confirmSynchronization(2, 7, revision), true);
  assert.deepEqual(queries[0].params, [7, 2, revision]);
  assert.match(queries[0].sql, /fk_id_pantalla = \$2/);
  assert.match(queries[0].sql, /::text\) = \$3/);
  assert.doesNotMatch(queries[0].sql, /fecha_actualizacion\s*=/);
});

test('video selection preserves dots and original extension', async (t) => {
  t.mock.method(fs, 'stat', async () => ({ isFile: () => true }));
  const update = t.mock.method(configurationRepository, 'changevideo', async () => ({ id: 7 }));
  await configurationService.changevideo(2, { name: 'promo.octubre.MP4' });
  assert.deepEqual(update.mock.calls[0].arguments, [2, 'promo.octubre', '.MP4']);
});

test('selection rejects traversal and missing files without saving', async (t) => {
  const update = t.mock.method(configurationRepository, 'changevideo', async () => ({ id: 7 }));
  await assert.rejects(configurationService.changevideo(2, { name: '../secret.mp4' }), { statusCode: 400 });
  t.mock.method(fs, 'stat', async () => { throw Object.assign(new Error('missing'), { code: 'ENOENT' }); });
  await assert.rejects(configurationService.changevideo(2, { name: 'missing.mp4' }), { statusCode: 404 });
  assert.equal(update.mock.callCount(), 0);
});
