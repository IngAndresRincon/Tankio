import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/main.dart';
import 'package:tankio/models/station_payment_gateway_model.dart';
import 'package:tankio/models/payment_gateway_created_model.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/station_service.dart';

class StationProvider extends ChangeNotifier {
  final Ref ref;

  StationProvider({required this.ref});

  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  StationService get _station => ref.read(stationServiceProvider);
  UserProvider get _user => ref.read(userProvider);

  List<StationPaymentGatewayModel> stationPoints = [];
  String initialValueStationPoint = "";
  String initialValuePaymentGateway = "";
  List<DropdownMenuItem<String>> listStationPoints = [];
  List<DropdownMenuItem<String>> listPaymentGatewayStation = [];
  final controllerAmountRecharge = TextEditingController(text: "0");

  List<Map<String, dynamic>> speedDialButtons = [
    {"id": 1, "moneyLabel": "\$ 10k", "moneyValue": "10000"},
    {"id": 2, "moneyLabel": "\$ 20k", "moneyValue": "20000"},
    {"id": 3, "moneyLabel": "\$ 50k", "moneyValue": "50000"},
    {"id": 4, "moneyLabel": "\$ 100k", "moneyValue": "100000"},
  ];

  StationPaymentGatewayModel? selectedChargingStation;
  StationGatewayModel? selectedPaymentGateway;
  PaymentGatewayCreatedModel? createdPayment;

  BuildContext? context = navigatorKey.currentContext;

  void clearFields() {
    stationPoints.clear();
    listStationPoints.clear();
    listPaymentGatewayStation.clear();
    initialValueStationPoint = "";
    initialValuePaymentGateway = "";
    selectedChargingStation = null;
    selectedPaymentGateway = null;
    createdPayment = null;
    controllerAmountRecharge.clear();
    notifyListeners();
  }

  Future<void> getPaymentGateWaysFromStation() async {
    _loading.show();
    try {
      listStationPoints.clear();
      stationPoints.clear();
      final response = await _station.paymentgatewaystation();
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['data'] as List<dynamic>? ?? [];
        stationPoints = data
            .map(
              (item) => StationPaymentGatewayModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();

        if (stationPoints.isNotEmpty) {
          initialValueStationPoint = stationPoints.first.stationId.toString();
          final seenStationIds = <int>{};
          for (final station in stationPoints) {
            if (!seenStationIds.add(station.stationId)) {
              continue;
            }
            final label = "${station.groupName} - ${station.stationName}";
            listStationPoints.add(
              DropdownMenuItem(
                value: station.stationId.toString(),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
        }
        if (listPaymentGatewayStation.isNotEmpty) {
          initialValuePaymentGateway =
              listPaymentGatewayStation.first.value ?? "";
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  Future<void> onChangeStation({required int idstation}) async {
    _loading.show();
    try {
      listPaymentGatewayStation.clear();
      initialValuePaymentGateway = "";
      selectedPaymentGateway = null;
      notifyListeners();
      selectedChargingStation = _findStationById(idstation);

      if (selectedChargingStation == null) return;
      initialValueStationPoint = selectedChargingStation!.stationId.toString();
      if (selectedChargingStation!.paymentGateways.isNotEmpty) {
        final seenGatewayIds = <int>{};
        for (final gateway in selectedChargingStation!.paymentGateways) {
          if (!seenGatewayIds.add(gateway.id)) {
            continue;
          }
          listPaymentGatewayStation.add(
            DropdownMenuItem(
              value: gateway.id.toString(),
              child: Text(
                gateway.name.toString().toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  Future<void> onChangePaymentGatway({required int idpayment}) async {
    _loading.show();
    try {
      selectedPaymentGateway = _findGatewayById(idpayment);
      initialValuePaymentGateway = idpayment.toString();

      if (selectedPaymentGateway == null) return;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  void speedButton({required String value}) {
    try {
      controllerAmountRecharge.text = int.parse(value).toString();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void validateValueField({required String value}) {
    try {
      //  if (productSelected == null) return;

      if (value.isEmpty) {
        controllerAmountRecharge.text = "0";
        return;
      }
      if (value.contains(RegExp(r'[.,]'))) {
        controllerAmountRecharge.text = "0";
        return;
      }

      if (int.parse(value) < 0) {
        controllerAmountRecharge.text = "0";
        return;
      }

      controllerAmountRecharge.text = int.parse(value).toString();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<bool> createPaymentGateway() async {
    _loading.show();
    try {
      if (selectedChargingStation == null || selectedPaymentGateway == null) {
        return false;
      }

      final int totalAmount =
          (int.tryParse(controllerAmountRecharge.text) ?? 0) +
          (selectedPaymentGateway?.transactionFee ?? 0);

      final Map payload = {
        "group_id": selectedChargingStation!.groupId,
        "station_id": selectedChargingStation!.stationId,
        "user_id": _user.userLogin!.info.user.id,
        "payment_gateway_id": selectedPaymentGateway!.id,
        "request_reference":
            "${selectedPaymentGateway!.name}-${selectedPaymentGateway!.id}",
        "request_type": selectedPaymentGateway!.name,
        "amount": totalAmount,
        "currency": "COP",
        "description": "top-up of balance via ${selectedPaymentGateway!.code}",
      };

      final response = await _station.createpaymentgateway(payload: payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        createdPayment = PaymentGatewayCreatedModel.fromJson(
          response.data['data'],
        );
        debugPrint(jsonEncode(createdPayment?.toJson()));
        return true;
      } else {
        debugPrint(jsonEncode(response.data['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  StationPaymentGatewayModel? _findStationById(int idstation) {
    for (final station in stationPoints) {
      if (station.stationId == idstation) {
        return station;
      }
    }
    return null;
  }

  StationGatewayModel? _findGatewayById(int idpayment) {
    final station = selectedChargingStation;
    if (station == null) {
      return null;
    }

    for (final gateway in station.paymentGateways) {
      if (gateway.id == idpayment) {
        return gateway;
      }
    }
    return null;
  }

  Future<void> qrScannerPositionCode() async {
    try {
      clearFields();
      notifyListeners();
      await Navigator.pushNamed(context!, '/qr-scanner-payment-gateway').then((
        value,
      ) async {
        if (value != null) {
          debugPrint(value.toString());
          await _findDispenserPaymentGatewayByPositionCode(
            code: value.toString(),
          );
        }
      });

      // await Navigator.pushNamedAndRemoveUntil(
      //   context!,
      //   '/qr-scanner-payment-gateway',
      //   (route) {
      //     return route.settings.name == '/home';
      //   },
      // ).then((value) {
      //   debugPrint(value.toString());
      // });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _findDispenserPaymentGatewayByPositionCode({
    required String code,
  }) async {
    _loading.show();
    try {
      final response = await _station.findDispenserPaymentGatewayByPositionCode(
        code: code,
      );
      if (response.statusCode == 200) {
        stationPoints.clear();
        final List<dynamic> data =
            response.data['data'] as List<dynamic>? ?? [];
        stationPoints = data
            .map(
              (item) => StationPaymentGatewayModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();

        if (stationPoints.isNotEmpty) {
          listStationPoints.clear();
          initialValueStationPoint = stationPoints.first.stationId.toString();

          final seenStationIds = <int>{};
          for (final station in stationPoints) {
            if (!seenStationIds.add(station.stationId)) {
              continue;
            }
            final label = "${station.groupName} - ${station.stationName}";
            listStationPoints.add(
              DropdownMenuItem(
                value: station.stationId.toString(),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
          await onChangeStation(idstation: int.parse(initialValueStationPoint));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }
}

final stationProvider = ChangeNotifierProvider<StationProvider>(
  (ref) => StationProvider(ref: ref),
);
