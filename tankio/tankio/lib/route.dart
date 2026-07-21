import 'package:flutter/material.dart';
import 'package:tankio/screen/activity.dart';
import 'package:tankio/screen/add_vehicle.dart';
import 'package:tankio/screen/balance_movements.dart';
import 'package:tankio/screen/change_password.dart';
import 'package:tankio/screen/create_account.dart';
import 'package:tankio/screen/delete_account.dart';
import 'package:tankio/screen/inselect_schedule.dart';
import 'package:tankio/screen/invoice.dart';
import 'package:tankio/screen/login.dart';
import 'package:tankio/screen/notifications.dart';
import 'package:tankio/screen/payment_gateway/epayco.dart';
import 'package:tankio/screen/payment_gateway/wompi.dart';
import 'package:tankio/screen/personal_information.dart';
import 'package:tankio/screen/qr_scanner.dart';
import 'package:tankio/screen/qr_scanner_payment_gateway.dart';
import 'package:tankio/screen/recover_password.dart';
import 'package:tankio/screen/security_settings.dart';
import 'package:tankio/screen/splash.dart';
import 'package:tankio/screen/biometric.dart';
import 'package:tankio/screen/home.dart';
import 'package:tankio/screen/tankio_schedule.dart';
import 'package:tankio/screen/terms_conditions.dart';
import 'package:tankio/screen/vehicles.dart';
import 'package:tankio/models/tankio_schedule_args.dart';
import 'package:tankio/screen/view_activity_electric_charger.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return _buildRoute(settings, const SplashScreen());
      case '/login_biometric':
        return _buildRoute(settings, const LoginBiometricScreen());
      case '/login':
        return _buildRoute(settings, const LoginScreen());
      case '/create-account':
        return _buildRoute(settings, const CreateAccountScreen());
      case '/recovery-password':
        return _buildRoute(settings, const RecoveryPasswordScreen());
      case '/home':
        return _buildRoute(settings, HomeScreen());
      case '/personal-information':
        return _buildRoute(settings, PersonalInformation());
      case '/change-password':
        return _buildRoute(settings, ChangePassword());
      case '/delete-account':
        return _buildRoute(settings, DeleteAccount());
      case '/security-settings':
        return _buildRoute(settings, SecuritySettings());
      case '/terms_&_conditions':
        return _buildRoute(settings, TermsConditions());
      case '/notifications':
        return _buildRoute(settings, Notifications());
      case '/qr-scanner':
        return _buildRoute(settings, QRScanner());
      case '/qr-scanner-payment-gateway':
        return _buildRoute(settings, QRScannerPaymentGateway());
      case '/vehicles':
        return _buildRoute(settings, Vehicles());
      case '/add-vehicles':
        return _buildRoute(settings, AddVehicle());
      case '/activity':
        return _buildRoute(settings, Activity());
      case '/tankio-schedule':
        final args = settings.arguments;
        final positionCode = args is TankioScheduleArgs
            ? args.positionCode
            : '';
        return _buildRoute(
          settings,
          TankioSchedule(positionCode: positionCode),
        );
      case '/inselect-schedule':
        final args = settings.arguments;
        final positionCode = args is InselectScheduleArgs
            ? args.positionCode
            : '';
        return _buildRoute(
          settings,
          InselectSchedule(positionCode: positionCode),
        );

      case '/invoice':
        final args = settings.arguments;
        final saleid = args is TankioSaleArgs ? args.saleId : 0;
        return _buildRoute(settings, Invoice(saleId: saleid));

      case '/activity-electric-charger':
        return _buildRoute(settings, ActivityElectricCharger());
      case '/balance-movements':
        return _buildRoute(settings, BalanceMovements());
      case '/epayco':
        return _buildRoute(settings, EpaycoCheckoutPage());
      case '/wompi':
        return _buildRoute(settings, WompiCheckoutPage());
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
