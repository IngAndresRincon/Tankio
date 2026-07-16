import 'package:flutter/material.dart';
import 'package:tankio_webpage/Screen/home.dart';
import 'package:tankio_webpage/Screen/login.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case '/splash':
      //   return _buildRoute(settings, const SplashScreen());
      case '/login':
        return _buildRoute(settings, const LoginPage());
      case '/home':
        return _buildRoute(settings, const HomePage());

      default:
        return _errorRoute(settings, 'Ruta no encontrada: ${settings.name}');
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => child);
  }

  static MaterialPageRoute<dynamic> _errorRoute(
    RouteSettings settings,
    String message,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => _RouteErrorPage(message: message),
    );
  }
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error de navegación')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
