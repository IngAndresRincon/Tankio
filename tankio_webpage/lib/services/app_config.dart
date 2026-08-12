import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  static String get baseUrl {
    const env = String.fromEnvironment('INSEPET_BASE_URL');
    if (env.isNotEmpty) {
      return env;
    }

    if (kIsWeb) {
      if (Uri.base.host.isNotEmpty) {
        return Uri(
          scheme: Uri.base.scheme,
          host: Uri.base.host,
          port: 40412,
        ).toString();
      }
    }

    return 'http://localhost:40412';
  }

  static String get socketUrl {
    const env = String.fromEnvironment('INSEPET_SOCKET_URL');
    if (env.isNotEmpty) {
      return env;
    }

    if (kIsWeb) {
      if (Uri.base.host.isNotEmpty) {
        return Uri(
          scheme: Uri.base.scheme,
          host: Uri.base.host,
          port: 40412,
        ).toString();
      }
    }

    return 'http://localhost:40412';
  }

  static const String apiKey = String.fromEnvironment(
    'TANKIO_API_KEY',
    defaultValue:
        '466d1a7023df1cefdbebdb87935fc95815b9ff5f5608fc90844e4384f69e2f2c',
  );
}
