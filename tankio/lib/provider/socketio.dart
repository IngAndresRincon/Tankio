import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as wsio;
import 'package:tankio/main.dart';
import 'package:tankio/provider/notification.dart';
import 'package:tankio/provider/schedule_inselect.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/app_config.dart';
import 'package:tankio/widget/modal/session_expired.dart';

class WSSocketIOProvider extends ChangeNotifier {
  final Ref ref;
  final String urlServer;
  bool sessionExpiredModalVisible = false;
  bool _sessionExpiredModalOpening = false;

  UserProvider get _user => ref.read(userProvider);
  ScheduleInselectProvider get _inselect => ref.read(inselectProvider.notifier);

  NotificationProvider get _notification =>
      ref.read(notificationProvider.notifier);

  BuildContext context;

  WSSocketIOProvider({
    required this.ref,
    required this.urlServer,
    required this.context,
  });
  wsio.Socket? _socket;
  bool _isConnecting = false;

  wsio.Socket? get socket => _socket;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void _destroySocket() {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
  }

  void markSessionExpiredHandled() {
    sessionExpiredModalVisible = false;
    _sessionExpiredModalOpening = false;
  }

  Future<void> initConnectSocket() async {
    if (_isConnecting) {
      return;
    }

    if (_socket != null && _socket!.connected) {
      _isConnected = true;
      return;
    }

    _destroySocket();
    _isConnecting = true;

    try {
      if (_user.userLogin == null) {
        return;
      }
      final jwkAuth = <String, dynamic>{'token': _user.userLogin!.token};

      _socket = wsio.io(
        urlServer,
        wsio.OptionBuilder()
            .setTransports(['websocket'])
            .enableReconnection()
            .setReconnectionAttempts(50)
            .setReconnectionDelay(2000)
            .setReconnectionDelayMax(10000)
            .disableMultiplex()
            .setAuth(jwkAuth)
            .build(),
      );

      _socket!.io.options?['extraHeaders'] = {
        'Authorization': 'Bearer ${_user.userLogin!.token}',
      };
      _socket!.auth = jwkAuth;

      _socket!.onConnect((_) {
        _isConnected = true;
        markSessionExpiredHandled();
        notifyListeners();
      });

      _socket!.onDisconnect((reason) {
        _isConnected = false;
        notifyListeners();
      });

      _socket!.onReconnect((attempt) {
        _socket!.emit("sync_check");
      });

      _socket!.onConnectError((data) async {
        debugPrint('Error de conexión socket: $data');

        if (sessionExpiredModalVisible || _sessionExpiredModalOpening) return;
        sessionExpiredModalVisible = true;
        _sessionExpiredModalOpening = true;

        final modalContext = navigatorKey.currentContext ?? context;

        await showModalBottomSheet(
          context: modalContext,
          isScrollControlled: true,
          isDismissible: false,
          useSafeArea: true,

          backgroundColor: Colors.transparent,
          builder: (_) {
            return SessionExpiredModal();
          },
        ).whenComplete(() {
          markSessionExpiredHandled();
        });

        //LoggerService.debug('Error de conexión socket: $data');
        // final context = navigatorKey.currentContext;
        // if (data.toString().contains("No autorizado") && context != null) {
        //   showDialog(
        //     barrierDismissible: false,
        //     barrierColor: Colors.black38,
        //     context: context,
        //     builder: (context) => SessionEndedModal(),
        //   );
        // }
      });

      _socket!.onError((data) {
        debugPrint('Error general socket: $data');
      });

      _socket!.on('notify_programming', (data) {
        _user.notifyUpdateActivityProgramming(data);
      });

      _socket!.on('notify_notification', (data) {
        _notification.reportActiveNotifications(data);
        //schedulesI.updateElectricCharginProcess(data);
      });

      _socket!.on('notify_position', (data) {
        if (data['system_id'] == 2) {
          _inselect.updateChargerData(data);
        }
      });
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> ensureSocketConnected() async {
    if (_user.userLogin == null) {
      return;
    }

    if (_socket == null || !_socket!.connected) {
      await initConnectSocket();
      return;
    }

    _isConnected = true;
  }

  void emit(String event, dynamic data) {
    if (_isConnected && _socket != null) {
      _socket!.emit(event, data);
    }
  }

  void disconnect() {
    _destroySocket();
  }

  @override
  void dispose() {
    _destroySocket();
    super.dispose();
  }
}

final socketControllerProvider = ChangeNotifierProvider<WSSocketIOProvider>(
  (ref) => WSSocketIOProvider(
    ref: ref,
    urlServer: AppConfig.socketUrl,
    context: navigatorKey.currentContext!,
  ),
);
