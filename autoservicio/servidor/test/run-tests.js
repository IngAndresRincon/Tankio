async function main() {
  await require('./totals.mapper.test')();
  await require('./sale.stop.test')();
  await require('./integration.routes.test')();
  console.log('All tests passed');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
