import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() => runApp(const BleConsoleApp());

const ink = Color(0xFF101A2A);
const paper = Color(0xFFF4F7FB);
const blue = Color(0xFF2864F0);
const targetDeviceName = 'EVCHARGER-001';
final targetServiceUuid = Guid('12345678-1234-5678-1234-56789abcdef0');
final targetCharacteristicUuid = Guid('12345678-1234-5678-1234-56789abcdef1');

class BleConsoleApp extends StatelessWidget {
  const BleConsoleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BLE Console',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      fontFamily: 'Roboto',
    ),
    home: const BleHomePage(),
  );
}

class BleHomePage extends StatefulWidget {
  const BleHomePage({super.key});

  @override
  State<BleHomePage> createState() => _BleHomePageState();
}

class _BleHomePageState extends State<BleHomePage> {
  final Map<String, ScanResult> _devices = {};
  final List<_LogEntry> _log = [];
  final _messageController = TextEditingController();
  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<BluetoothConnectionState>? _connectionSub;
  StreamSubscription<String>? _notifySub;
  BluetoothDevice? _device;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  BluetoothCharacteristic? _tx;
  BluetoothCharacteristic? _rx;
  List<BluetoothService> _services = [];
  String? _error;
  bool _scanning = false;
  bool _connecting = false;
  bool _sending = false;
  bool _autoReconnectEnabled = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  // Reintentos mientras la app esté abierta y el usuario no desconecte.
  static const Duration _reconnectInterval = Duration(seconds: 5);

  bool get _connected => _connectionState == BluetoothConnectionState.connected;
  List<BluetoothCharacteristic> get _characteristics => [
    for (final service in _services) ...service.characteristics,
  ];

  @override
  void initState() {
    super.initState();
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      if (!mounted) return;
      setState(() => _adapterState = state);
      if (state != BluetoothAdapterState.on) {
        _reconnectTimer?.cancel();
        if (_scanning) {
          FlutterBluePlus.stopScan();
          setState(() => _scanning = false);
        }
      } else if (_autoReconnectEnabled && !_connected && !_connecting) {
        _scheduleReconnect();
      }
    }, onError: (Object e) => _reportError('Bluetooth: $e'));
    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) return;
      setState(() {
        for (final result in results) {
          final platformName = result.device.platformName.trim().toUpperCase();
          final advertisedName = result.advertisementData.advName
              .trim()
              .toUpperCase();

          if (platformName == targetDeviceName ||
              advertisedName == targetDeviceName) {
            _devices[result.device.remoteId.str] = result;
          }
        }
      });
    }, onError: (Object e) => _reportError('Error durante la búsqueda: $e'));
  }

  @override
  void dispose() {
    _autoReconnectEnabled = false;
    _reconnectTimer?.cancel();
    _scanSub?.cancel();
    _adapterSub?.cancel();
    _connectionSub?.cancel();
    _notifySub?.cancel();
    _messageController.dispose();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  void _reportError(String message) {
    if (!mounted) return;
    setState(() => _error = message);
    _addLog('ERROR', message, isError: true);
  }

  void _addLog(String direction, String text, {bool isError = false}) {
    if (!mounted) return;
    setState(() {
      _log.insert(0, _LogEntry(DateTime.now(), direction, text, isError));
      if (_log.length > 100) _log.removeLast();
    });
  }

  Future<void> _scan() async {
    if (_adapterState != BluetoothAdapterState.on) {
      _reportError('Activa Bluetooth en el dispositivo para buscar equipos.');
      return;
    }
    setState(() {
      _error = null;
      _devices.clear();
      _scanning = true;
    });
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 12));
      await Future<void>.delayed(const Duration(seconds: 12));
    } catch (e) {
      _reportError('No se pudo iniciar la búsqueda: $e');
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  void _scheduleReconnect() {
    if (!mounted ||
        !_autoReconnectEnabled ||
        _device == null ||
        _adapterState != BluetoothAdapterState.on ||
        _connected ||
        _connecting) {
      return;
    }
    if (_reconnectTimer?.isActive ?? false) return;

    _addLog('INFO', 'Conexión perdida. Reintento automático cada 5 segundos.');
    _reconnectTimer = Timer.periodic(_reconnectInterval, (timer) async {
      if (!mounted ||
          !_autoReconnectEnabled ||
          _device == null ||
          _adapterState != BluetoothAdapterState.on ||
          _connected) {
        timer.cancel();
        return;
      }
      if (_connecting) return;
      _reconnectAttempts++;
      _addLog('INFO', 'Reconexión #$_reconnectAttempts...');
      await _connect(_device!, automatic: true);
    });
  }

  Future<void> _connect(
    BluetoothDevice device, {
    bool automatic = false,
  }) async {
    if (_connecting) return;
    if (!automatic) {
      _autoReconnectEnabled = true;
      _reconnectAttempts = 0;
    }
    _reconnectTimer?.cancel();
    setState(() {
      _connecting = true;
      _error = null;
      _device = device;
      _services = [];
      _tx = null;
      _rx = null;
    });

    await _notifySub?.cancel();
    _notifySub = null;
    await _connectionSub?.cancel();
    _connectionSub = device.connectionState.listen((state) {
      if (!mounted || _device?.remoteId != device.remoteId) return;
      final wasConnected =
          _connectionState == BluetoothConnectionState.connected;
      setState(() => _connectionState = state);
      if (state == BluetoothConnectionState.disconnected) {
        _notifySub?.cancel();
        _notifySub = null;
        setState(() {
          _services = [];
          _tx = null;
          _rx = null;
        });
        if (wasConnected) {
          _addLog('INFO', 'Dispositivo desconectado.');
        }
        if (!_connecting) _scheduleReconnect();
      }
    }, onError: (Object e) => _reportError('Estado de conexión: $e'));

    try {
      await device.connect(
        license: License.commercial,
        timeout: const Duration(seconds: 15),
      );
      if (!mounted || !_autoReconnectEnabled) return;

      final services = await device.discoverServices();
      if (!mounted || !_autoReconnectEnabled) return;

      BluetoothCharacteristic? target;
      for (final service in services) {
        if (service.uuid != targetServiceUuid) continue;
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid == targetCharacteristicUuid) {
            target = characteristic;
            break;
          }
        }
        break;
      }
      if (target == null) {
        throw Exception('No se encontró la característica del EVCHARGER');
      }
      if (!target.properties.write && !target.properties.writeWithoutResponse) {
        throw Exception('La característica no permite escritura');
      }
      if (!target.properties.notify && !target.properties.indicate) {
        throw Exception('La característica no permite notificaciones');
      }

      // Activar Notify antes de habilitar el envío de mensajes.
      await _enableNotifications(target);
      if (!mounted || !_autoReconnectEnabled) return;
      setState(() {
        _services = services;
        _tx = target;
        _rx = target;
        _connectionState = BluetoothConnectionState.connected;
      });
      _reconnectAttempts = 0;
      _addLog(
        'INFO',
        automatic
            ? 'Reconectado. TX/RX y Notify restaurados.'
            : 'Conectado. TX/RX y Notify listos: ${target.uuid}',
      );
    } catch (e) {
      _reportError('No se pudo conectar o descubrir servicios: $e');
      try {
        await device.disconnect();
      } catch (_) {}
    } finally {
      if (mounted) {
        setState(() {
          _connecting = false;
        });
        if (!_connected) _scheduleReconnect();
      }
    }
  }

  Future<void> _disconnect() async {
    _autoReconnectEnabled = false;
    _reconnectTimer?.cancel();
    final device = _device;
    if (device == null) return;
    try {
      await device.disconnect();
      if (mounted) {
        setState(() {
          _tx = null;
          _rx = null;
          _connectionState = BluetoothConnectionState.disconnected;
        });
      }
      _addLog('INFO', 'Desconectado manualmente. Reconexión desactivada.');
    } catch (e) {
      _reportError('Error al desconectar: $e');
    }
  }

  Future<void> _reconnect() async {
    final device = _device;
    if (device == null) return;
    await _connect(device);
  }

  Future<void> _selectTx(BluetoothCharacteristic? value) async {
    setState(() => _tx = value);
  }

  Future<void> _selectRx(BluetoothCharacteristic? value) async {
    await _notifySub?.cancel();
    setState(() => _rx = value);
    if (value != null &&
        (value.properties.notify || value.properties.indicate)) {
      await _enableNotifications(value);
    }
  }

  Future<void> _enableNotifications(
    BluetoothCharacteristic characteristic,
  ) async {
    try {
      await _notifySub?.cancel();
      _notifySub = utf8.decoder.bind(characteristic.onValueReceived).listen((
        text,
      ) {
        _addLog('RX', text);
      }, onError: (Object e) => _reportError('Error al recibir datos: $e'));
      _device?.cancelWhenDisconnected(_notifySub!);
      await characteristic.setNotifyValue(true);
      _addLog('INFO', 'Escucha activada en ${characteristic.uuid}.');
    } catch (e) {
      _reportError('No se pudieron activar notificaciones: $e');
    }
  }

  Future<void> _send() async {
    final characteristic = _tx;
    final text = _messageController.text;
    if (!_connected || _connecting || characteristic == null) {
      _reportError(
        'Conecta un dispositivo y selecciona una característica de escritura.',
      );
      return;
    }
    if (text.isEmpty) return;
    final bytes = utf8.encode(text);
    setState(() => _sending = true);
    try {
      await characteristic.write(
        bytes,
        withoutResponse:
            !characteristic.properties.write &&
            characteristic.properties.writeWithoutResponse,
      );
      _addLog('TX', text);
      _messageController.clear();
    } catch (e) {
      _reportError('No se pudo enviar el mensaje: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  String _deviceName(BluetoothDevice device) => device.platformName.isNotEmpty
      ? device.platformName
      : 'Dispositivo sin nombre';
  String _adapterLabel(BluetoothAdapterState state) => switch (state) {
    BluetoothAdapterState.on => 'Bluetooth activo',
    BluetoothAdapterState.off => 'Bluetooth apagado',
    BluetoothAdapterState.unauthorized => 'Permiso requerido',
    BluetoothAdapterState.unavailable => 'No disponible',
    _ => 'Comprobando Bluetooth',
  };

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 760;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 350, child: _devicePanel()),
                              const SizedBox(width: 18),
                              Expanded(child: _consolePanel()),
                            ],
                          )
                        : ListView(
                            children: [
                              _connectionCard(),
                              const SizedBox(height: 16),
                              _devicePanel(),
                              const SizedBox(height: 16),
                              SizedBox(height: 510, child: _consolePanel()),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
    color: ink,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: blue,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.bluetooth, color: Colors.white),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BLE CONSOLE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Terminal Bluetooth Low Energy',
                style: TextStyle(color: Color(0xFF9EACC1), fontSize: 12),
              ),
            ],
          ),
        ),
        _statusPill(
          _connected
              ? 'CONECTADO'
              : _scanning
              ? 'BUSCANDO'
              : _autoReconnectEnabled && _device != null
              ? 'RECONECTANDO'
              : 'DESCONECTADO',
          _connected
              ? const Color(0xFF38D39F)
              : _scanning
              ? const Color(0xFFFFC857)
              : const Color(0xFF8190A6),
        ),
      ],
    ),
  );

  Widget _connectionCard() => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(17),
    decoration: _cardDecoration(),
    child: Row(
      children: [
        Icon(
          _connected ? Icons.link : Icons.link_off,
          color: _connected ? const Color(0xFF1DAD7A) : Colors.blueGrey,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _device == null ? 'Sin dispositivo' : _deviceName(_device!),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                _device?.remoteId.str ?? _adapterLabel(_adapterState),
                style: const TextStyle(color: Color(0xFF8290A3), fontSize: 12),
              ),
            ],
          ),
        ),
        if (_connecting)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else if (_connected)
          IconButton(
            onPressed: _disconnect,
            icon: const Icon(Icons.link_off),
            tooltip: 'Desconectar',
          )
        else if (_device != null)
          IconButton(
            onPressed: _reconnect,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reconectar',
          ),
      ],
    ),
  );

  Widget _devicePanel() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (MediaQuery.sizeOf(context).width > 760) _connectionCard(),
      Container(
        decoration: _cardDecoration(),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: _SectionTitle(
                    icon: Icons.radar,
                    title: 'Dispositivos',
                    subtitle: 'Equipos BLE cercanos',
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _scanning ? null : _scan,
                  icon: Icon(_scanning ? Icons.hourglass_top : Icons.refresh),
                  tooltip: 'Buscar dispositivos',
                ),
              ],
            ),
            const SizedBox(height: 13),
            if (_error != null) _errorBanner(_error!),
            if (_scanning) const LinearProgressIndicator(minHeight: 2),
            if (_devices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        _scanning
                            ? Icons.bluetooth_searching
                            : Icons.bluetooth_disabled,
                        size: 34,
                        color: const Color(0xFF9BA8B9),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        _scanning
                            ? 'Buscando señales cercanas…'
                            : 'Busca dispositivos para comenzar',
                        style: const TextStyle(
                          color: Color(0xFF8290A3),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).width > 760 ? 470 : 300,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _devices.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 54),
                  itemBuilder: (context, index) {
                    final result = _devices.values.elementAt(index);
                    final device = result.device;
                    final selected = _device?.remoteId == device.remoteId;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                      leading: CircleAvatar(
                        backgroundColor: selected
                            ? const Color(0xFFE7EEFF)
                            : const Color(0xFFF0F3F8),
                        child: Icon(
                          Icons.bluetooth,
                          color: selected ? blue : const Color(0xFF77859A),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        _deviceName(device),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${device.remoteId.str}  ·  ${result.rssi} dBm',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8592A4),
                        ),
                      ),
                      trailing: selected && _connected
                          ? const Icon(
                              Icons.check_circle,
                              color: Color(0xFF20B27D),
                              size: 20,
                            )
                          : TextButton(
                              onPressed: _connecting
                                  ? null
                                  : () => _connect(device),
                              child: Text(
                                selected ? 'REINTENTAR' : 'CONECTAR',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            if (_devices.isEmpty) const SizedBox(height: 6),
            if (_devices.isEmpty)
              FilledButton.icon(
                onPressed: _scanning ? null : _scan,
                icon: const Icon(Icons.search, size: 18),
                label: Text(_scanning ? 'Buscando…' : 'Buscar dispositivos'),
              ),
          ],
        ),
      ),
    ],
  );

  Widget _consolePanel() => Container(
    decoration: _cardDecoration(),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 17, 18, 12),
          child: Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  icon: Icons.terminal,
                  title: 'Consola de mensajes',
                  subtitle: 'Texto UTF‑8 bidireccional',
                ),
              ),
              TextButton.icon(
                onPressed: _log.isEmpty ? null : () => setState(_log.clear),
                icon: const Icon(Icons.delete_outline, size: 17),
                label: const Text('Limpiar'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _log.isEmpty
              ? const Center(
                  child: Text(
                    'Los mensajes enviados y recibidos aparecerán aquí.',
                    style: TextStyle(color: Color(0xFF98A4B4), fontSize: 13),
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(14),
                  itemCount: _log.length,
                  itemBuilder: (_, index) => _logTile(_log[index]),
                ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 15),
          decoration: const BoxDecoration(
            color: Color(0xFFFAFBFD),
            border: Border(top: BorderSide(color: Color(0xFFE9EDF3))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _characteristicDropdown(
                      'TX · Escritura',
                      _tx,
                      _selectTx,
                      (c) =>
                          c.properties.write ||
                          c.properties.writeWithoutResponse,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _characteristicDropdown(
                      'RX · Notificaciones',
                      _rx,
                      _selectRx,
                      (c) => c.properties.notify || c.properties.indicate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: _connected,
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: _connected
                            ? 'Escribe un mensaje UTF‑8…'
                            : 'Conecta un dispositivo para enviar',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            color: Color(0xFFE1E7EF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            color: Color(0xFFE1E7EF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  SizedBox(
                    height: 49,
                    child: FilledButton(
                      onPressed: _sending || !_connected || _connecting
                          ? null
                          : _send,
                      style: FilledButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Los mensajes se envían tal cual, codificados en UTF‑8. BLE puede dividir datos largos en varios paquetes.',
                style: TextStyle(fontSize: 10, color: Color(0xFF98A4B4)),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _characteristicDropdown(
    String label,
    BluetoothCharacteristic? value,
    ValueChanged<BluetoothCharacteristic?> onChanged,
    bool Function(BluetoothCharacteristic) predicate,
  ) {
    final options = _characteristics.where(predicate).toList();
    final validValue = _firstOrNull(options.where((c) => c == value));
    return DropdownButtonFormField<BluetoothCharacteristic>(
      value: validValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 10,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
      ),
      hint: Text(
        options.isEmpty ? 'Sin características' : 'Selecciona característica',
        style: const TextStyle(fontSize: 11),
      ),
      items: options
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(
                c.uuid.toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          )
          .toList(),
      onChanged: null, // Selección automática por UUID
    );
  }

  Widget _logTile(_LogEntry entry) {
    final color = entry.isError
        ? const Color(0xFFC83E4D)
        : entry.direction == 'TX'
        ? blue
        : entry.direction == 'RX'
        ? const Color(0xFF118664)
        : const Color(0xFF7A8798);
    final hex = entry.direction == 'TX' || entry.direction == 'RX'
        ? utf8
              .encode(entry.text)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join(' ')
        : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: entry.isError
            ? const Color(0xFFFFF3F3)
            : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isError
              ? const Color(0xFFF5D4D7)
              : const Color(0xFFEBEFF5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  entry.direction,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    letterSpacing: .7,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${entry.time.hour.toString().padLeft(2, '0')}:${entry.time.minute.toString().padLeft(2, '0')}:${entry.time.second.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Color(0xFF9AA5B4), fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SelectableText(
            entry.text,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: entry.isError ? const Color(0xFFAD3340) : ink,
            ),
          ),
          if (hex.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SelectableText(
                'HEX  $hex',
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF98A4B4),
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _errorBanner(String error) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF3F3),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, size: 17, color: Color(0xFFC83E4D)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            error,
            style: const TextStyle(fontSize: 11, color: Color(0xFFAD3340)),
          ),
        ),
      ],
    ),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xFFE9EDF3)),
    boxShadow: const [
      BoxShadow(color: Color(0x0A14243A), blurRadius: 18, offset: Offset(0, 6)),
    ],
  );

  Widget _statusPill(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: .28)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9,
            letterSpacing: .7,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFEDF2FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: blue, size: 18),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Color(0xFF8A97A8)),
            ),
          ],
        ),
      ),
    ],
  );
}

class _LogEntry {
  const _LogEntry(this.time, this.direction, this.text, this.isError);
  final DateTime time;
  final String direction;
  final String text;
  final bool isError;
}

T? _firstOrNull<T>(Iterable<T> values) {
  final iterator = values.iterator;
  return iterator.moveNext() ? iterator.current : null;
}
