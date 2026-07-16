import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/models/dispenser_position_model.dart';
import 'package:tankio/models/programming_model.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/tankio_service.dart';
import 'package:tankio/utils/money_utils.dart';

class ScheduleTankioProvider extends ChangeNotifier {
  final Ref ref;
  ScheduleTankioProvider({required this.ref});

  UserProvider get _user => ref.read(userProvider);
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  TankioService get _tankio => ref.read(tankioServiceProvider);

  final int buttonMoneyValue = 1000;
  final double buttonVolumeValue = 1;

  List<DispenserPositionModel> listDispenserPosition = [];

  List<DropdownMenuItem<String>> schedulingtype = const [
    DropdownMenuItem(value: '1', child: Text('MONEY')),
    DropdownMenuItem(value: '2', child: Text('VOLUME')),
  ];

  List<Map<String, dynamic>> speedDialButtons = [
    {
      "id": 1,
      "moneyLabel": "\$ 10k",
      "moneyValue": "10000",
      "volumeLabel": "1.0 G",
      "volumeValue": "1",
    },
    {
      "id": 2,
      "moneyLabel": "\$ 20k",
      "moneyValue": "20000",
      "volumeLabel": "2.0 G",
      "volumeValue": "2",
    },
    {
      "id": 3,
      "moneyLabel": "\$ 50k",
      "moneyValue": "50000",
      "volumeLabel": "5.0 G",
      "volumeValue": "5",
    },
    {
      "id": 4,
      "moneyLabel": "\$ 100k",
      "moneyValue": "100000",
      "volumeLabel": "10.0 G",
      "volumeValue": "10",
    },
  ];

  final controllerValue = TextEditingController(text: "0");
  final controllerSchedulingType = TextEditingController(text: "1");
  final controllerVehicle = TextEditingController();

  String moneyCalculate = "0";
  String volumeCalculate = "0";
  DispenserPositionModel? productSelected;
  ProgrammingResponseModel? programming;

  void clearFields() {
    controllerValue.text = "0";
    controllerSchedulingType.text = "1";
    productSelected = null;
    moneyCalculate = "0";
    volumeCalculate = "0";
  }

  Future<void> getDispenserPositionByCode({required String code}) async {
    _loading.show();
    try {
      listDispenserPosition.clear();
      await Future.delayed(const Duration(seconds: 3));
      final response = await _tankio.getDispenserPositionByCode(code: code);
      if (response.statusCode == 200) {
        debugPrint(jsonEncode(response.data['data']));
        List<dynamic> list = response.data['data'];
        if (list.isNotEmpty) {
          for (dynamic e in list) {
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
    moneyCalculate = "0";
    volumeCalculate = "0";
    productSelected = listDispenserPosition.firstWhere(
      (e) => e.hoseId == hoseid,
    );
    if (productSelected == null) return;
  }

  void validateValueField({required String value}) {
    try {
      if (productSelected == null) return;

      if (value.isEmpty) {
        controllerValue.text = "0";
        return;
      }
      if (int.parse(controllerSchedulingType.text) == 1) //Dinero
      {
        final parsedValue = parseMoney(value);
        if (parsedValue < 0) {
          controllerValue.text = "0";
          return;
        }

        controllerValue.text = normalizeMoneyInput(value);
      }

      if (int.parse(controllerSchedulingType.text) == 2) //Dinero
      {
        final parsedValue = parseMoney(value);
        if (parsedValue < 0) {
          controllerValue.text = "0";
          return;
        }
        controllerValue.text = normalizeMoneyInput(value);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }
  }

  void addButton() {
    try {
      if (productSelected == null) return;

      if (int.parse(controllerSchedulingType.text) == 1) //Dinero
      {
        final fieldValue = parseMoney(controllerValue.text) + buttonMoneyValue;
        controllerValue.text = formatMoney(fieldValue);
      }
      if (int.parse(controllerSchedulingType.text) == 2) //Volumen
      {
        double fieldValue = double.parse(controllerValue.text);
        fieldValue += buttonVolumeValue;
        controllerValue.text = fieldValue.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }
  }

  void minusButton() {
    try {
      if (productSelected == null) return;

      if (int.parse(controllerSchedulingType.text) == 1) //Dinero
      {
        final fieldValue = parseMoney(controllerValue.text) - buttonMoneyValue;
        controllerValue.text = fieldValue < 0 ? "0" : formatMoney(fieldValue);
      }
      if (int.parse(controllerSchedulingType.text) == 2) //Volumen
      {
        double fieldValue = double.parse(controllerValue.text);
        fieldValue -= buttonVolumeValue;
        controllerValue.text = fieldValue < 0 ? "0" : fieldValue.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }
  }

  void speedButton({required String value}) {
    try {
      if (productSelected == null) return;

      if (int.parse(controllerSchedulingType.text) == 1) {
        controllerValue.text = formatMoney(parseMoney(value));
      }
      if (int.parse(controllerSchedulingType.text) == 2) {
        controllerValue.text = double.parse(value).toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      calculateValues();
      notifyListeners();
    }
  }

  void calculateValues() {
    if (productSelected == null) return;

    if (int.parse(controllerSchedulingType.text) == 1) {
      moneyCalculate = normalizeMoneyInput(controllerValue.text);
      volumeCalculate = (parseMoney(moneyCalculate) / productSelected!.price)
          .toStringAsFixed(2);
    }

    if (int.parse(controllerSchedulingType.text) == 2) {
      volumeCalculate = controllerValue.text;
      moneyCalculate = (double.parse(volumeCalculate) * productSelected!.price)
          .toStringAsFixed(2);
    }
  }

  Future<bool> createProgramming() async {
    _loading.show();
    try {
      final Map body = {
        "stationid": productSelected!.stationId,
        "userid": _user.userLogin!.info.user.id,
        "identifier": controllerVehicle.text,
        "dispenserid": productSelected!.dispenserId,
        "positionid": productSelected!.positionId,
        "hoseid": productSelected!.hoseId,
        "price": productSelected!.price,
        "programmingtype": int.parse(controllerSchedulingType.text) == 1
            ? "MONEY"
            : "VOLUME",
        "programmingvalue": double.parse(controllerValue.text),
        "programmingmoney": parseMoney(moneyCalculate),
        "balance": 0,
        "systemid": 1, // 1 Para sistema tankio
        "sourceid": 1,
        "localpayment": false,
        "booking": false,
      };

      final response = await _tankio.createProgramming(body: body);
      if (response.statusCode == 200) {
        programming = ProgrammingResponseModel.fromJson(response.data['data']);
        return true;
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

      final response = await _tankio.changeStatusProgramming(
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
}

final tankioProvider = ChangeNotifierProvider<ScheduleTankioProvider>(
  (ref) => ScheduleTankioProvider(ref: ref),
);
