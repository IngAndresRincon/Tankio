import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/main.dart';
import 'package:tankio/models/dispenser_position_model.dart';
import 'package:tankio/models/programming_model.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/inselect_service.dart';
import 'package:tankio/utils/enum.dart';
import 'package:tankio/widget/modal/status_modal.dart';

class ScheduleInselectProvider extends ChangeNotifier {
  final Ref ref;
  ScheduleInselectProvider({required this.ref});

  UserProvider get _user => ref.read(userProvider);
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  InselectService get _inselect => ref.read(inselectServiceProvider);

  final int buttonMoneyValue = 1000;
  final controllerValue = TextEditingController(text: "0");
  final controllerVehicle = TextEditingController();
  List<DispenserPositionModel> listDispenserPosition = [];
  DispenserPositionModel? productSelected;
  String moneyCalculate = "0";
  String powerCalculate = "0";
  ProgrammingResponseModel? programming;
  bool isValidBalanceGroup = true;
  BuildContext? context = navigatorKey.currentContext;

  // Datos de la carga

  double currentValue = 0;
  double voltageValue = 0;
  int powerValue = 0;
  int totalEnergy = 0;
  int estimatedCost = 0;
  double electricChargePercentage = 0;
  String? uuidProgramming;
  String? statusChager;
  int programmingStatusId = 0;

  // Datos de la carga

  List<Map<String, dynamic>> speedDialButtons = [
    {"id": 1, "moneyLabel": "\$ 10k", "moneyValue": "10000"},
    {"id": 2, "moneyLabel": "\$ 20k", "moneyValue": "20000"},
    {"id": 3, "moneyLabel": "\$ 50k", "moneyValue": "50000"},
    {"id": 4, "moneyLabel": "\$ 100k", "moneyValue": "100000"},
  ];

  Future<void> getDispenserPositionByCode({required String code}) async {
    _loading.show();
    try {
      isValidBalanceGroup = true;
      listDispenserPosition.clear();
      final response = await _inselect.getDispenserPositionByCode(code: code);
      if (response.statusCode == 200) {
        debugPrint(jsonEncode(response.data['data']));
        List<dynamic> list = response.data['data'];
        if (list.isNotEmpty) {
          for (dynamic e in list) {
            if (e['group_id'] != _user.userLogin!.info.balance!.groupId) {
              isValidBalanceGroup = false;
            }
            if (e['status'].toString().toLowerCase() == "cargando" &&
                (e['hose_in_use'] == e['hose_number'])) {
              continue;
            }
            listDispenserPosition.add(DispenserPositionModel.fromJson(e));
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  void selectProduct({required int hoseid}) {
    controllerValue.text = "0";
    productSelected = listDispenserPosition.firstWhere(
      (e) => e.hoseId == hoseid,
    );
    if (productSelected == null) return;
  }

  bool validateValueField({required String value}) {
    try {
      if (productSelected == null) return false;

      if (value.isEmpty) {
        controllerValue.text = "0";
        return false;
      }

      if (value.contains(RegExp(r'[.,]'))) {
        controllerValue.text = "0";
        return false;
      }

      if (int.parse(value) < 0) {
        controllerValue.text = "0";
        return false;
      }

      if (int.parse(value) < productSelected!.price) {
        controllerValue.text = int.parse(value).toString();
        return false;
      }

      controllerValue.text = int.parse(value).toString();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }
    return true;
  }

  bool addButton() {
    try {
      if (productSelected == null) return false;

      int fieldValue = int.parse(controllerValue.text);
      fieldValue += buttonMoneyValue;
      controllerValue.text = fieldValue.toString();

      if (fieldValue < productSelected!.price) {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }
    return true;
  }

  bool minusButton() {
    try {
      if (productSelected == null) return false;

      int fieldValue = int.parse(controllerValue.text);
      fieldValue -= buttonMoneyValue;
      controllerValue.text = fieldValue < 0 ? "0" : fieldValue.toString();

      if (fieldValue < productSelected!.price) {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }
    return true;
  }

  bool speedButton({required String value}) {
    try {
      if (productSelected == null) return false;
      controllerValue.text = int.parse(value).toString();

      if (int.parse(value) < productSelected!.price) {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }

    return true;
  }

  void calculateValues() {
    if (productSelected == null) return;

    moneyCalculate = controllerValue.text;
    powerCalculate =
        ((double.parse(moneyCalculate) * 1000) / productSelected!.price)
            .toStringAsFixed(2);
  }

  Future<bool?> createProgramming() async {
    _loading.show();
    try {
      if (int.parse(moneyCalculate) > _user.userLogin!.info.balance!.balance) {
        return null;
      }

      final Map body = {
        "stationid": productSelected!.stationId,
        "userid": _user.userLogin!.info.user.id,
        "identifier": controllerVehicle.text,
        "dispenserid": productSelected!.dispenserId,
        "positionid": productSelected!.positionId,
        "hoseid": productSelected!.hoseId,
        "controllerid": productSelected!.controllerId,
        "price": productSelected!.price,
        "programmingtype": "ENERGY",
        "programmingvalue": double.parse(powerCalculate).toInt(),
        "programmingmoney": moneyCalculate,
        "balance": _user.userLogin!.info.balance!.balance,
        "systemid": 2, // 2 Para sistema inselect
        "sourceid": 1,
        "localpayment": false,
        "booking": false,
      };
      final response = await _inselect.createProgramming(body: body);
      if (response.statusCode == 201) {
        programming = ProgrammingResponseModel.fromJson(response.data['data']);
        return true;
      }
      if (response.statusCode == 409) {
        AppStatusModal.show(
          context: context!,
          type: AppModalType.error,
          title: "Error",
          message: response.data['message'],
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<void> changeStatusProgramming(String uuid, int status) async {
    //_loading.show();
    try {
      final newStatus = {"programming_status_id": status};

      final response = await _inselect.changeStatusProgramming(
        uuid: uuid,
        body: newStatus,
      );

      if (response.statusCode == 200) {
        debugPrint(jsonEncode(response.data));
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      //_loading.hide();
    }
  }

  Future<void> updateChargerData(Map data) async {
    try {
      programmingStatusId = data['programming_status_id'];
      uuidProgramming = data['uuid'];
      statusChager = data['status'];
      currentValue = double.parse(data['current'].toString());
      voltageValue = double.parse(data['voltage'].toString());
      powerValue = data['power'];
      totalEnergy = int.parse(data['programming_value'].toString());
      electricChargePercentage =
          (data['power'] * 1) / data['programming_value'];
      estimatedCost = double.parse(
        ((data['power'] * data['programming_money']) /
                data['programming_value'])
            .toString(),
      ).toInt();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void clearFieldCharger() {
    uuidProgramming = null;
    statusChager = null;
    currentValue = 0;
    voltageValue = 0;
    powerValue = 0;
    totalEnergy = 0;
    electricChargePercentage = 0;
    estimatedCost = 0;
    notifyListeners();
  }
}

final inselectProvider = ChangeNotifierProvider<ScheduleInselectProvider>(
  (ref) => ScheduleInselectProvider(ref: ref),
);
