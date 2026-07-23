class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'INSEPET_BASE_URL',
    // defaultValue: 'https://subdivinely-unreciprocal-hee.ngrok-free.dev',
    defaultValue: 'https://grateful-november-specialty-stand.trycloudflare.com',
    //defaultValue: 'http://18.204.225.239:3001',
  );

  static const String socketUrl = String.fromEnvironment(
    'INSEPET_SOCKET_URL',
    // defaultValue: 'https://subdivinely-unreciprocal-hee.ngrok-free.dev',
    defaultValue: 'https://grateful-november-specialty-stand.trycloudflare.com',
    //defaultValue: 'http://192.168.120.149:3000',
  );

  static const String apiKey = String.fromEnvironment(
    'TANKIO_API_KEY',
    defaultValue:
        '466d1a7023df1cefdbebdb87935fc95815b9ff5f5608fc90844e4384f69e2f2c',
  );
}
