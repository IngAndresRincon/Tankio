import 'package:aplicacion/screen/index.dart';
import 'package:aplicacion/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return _buildRoute(settings, const SplashScreen());
      case '/index':
        return _buildRoute(settings, const IndexScreen());
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
    debugPrint(message);
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const _RouteErrorPage(),
    );
  }
}

class _RouteErrorPage extends ConsumerStatefulWidget {
  const _RouteErrorPage();

  @override
  ConsumerState<_RouteErrorPage> createState() => _RouteErrorPageState();
}

class _RouteErrorPageState extends ConsumerState<_RouteErrorPage> {
  bool returningToVideo = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * .06,
                vertical: 30,
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 760),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .045,
                  vertical: 36,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
