const assert = require('node:assert/strict');
const { buildTotalsList } = require('../src/modules/totals/totals.mapper');

module.exports = async function testTotalsMapper() {
  assert.equal(buildTotalsList([]), null);
  assert.equal(buildTotalsList(null), null);

  assert.deepEqual(
    buildTotalsList([
      {
        position: 1,
        face: 'A',
        nummangueras: 2,
        totales_dinero_0: 100,
        totales_volumen_0: 10,
        totales_dinero_1: 200,
        totales_volumen_1: 20
      }
    ]),
    [
      {
        position: 1,
        face: 'A',
        hoses: [
          { hose: 1, money: 100, volume: 10 },
          { hose: 2, money: 200, volume: 20 }
        ]
      }
    ]
  );
};
