import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/models/vehicle_by_user_id.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/vehicle_service.dart';

class VehicleProvider extends ChangeNotifier {
  final Ref ref;
  VehicleProvider({required this.ref});

  //Controladores para registro
  final controllerVehiclePlateNumber = TextEditingController();
  final controllerVehicleType = TextEditingController();
  final controllerVehicleBrand = TextEditingController();
  final controllerVehicleModel = TextEditingController();
  final controllerVehicleConnector = TextEditingController();

  //Controladores para registro

  //Listas
  List<DropdownMenuItem<String>> listVehicleType = [];
  List<DropdownMenuItem<String>> listVehicleBrand = [];
  List<DropdownMenuItem<String>> listVehicleModel = [];
  List<DropdownMenuItem<String>> listVehicleConnector = [];
  List<VehicleModel> vehicles = [];

  //Listas

  VehicleService get _vehicle => ref.read(vehicleServiceProvider);
  UserProvider get _user => ref.read(userProvider);
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);

  Future<bool> getListVehicleByUserId({bool validEnable = false}) async {
    try {
      _loading.show();
      vehicles.clear();
      final int userid = _user.userLogin!.info.user.id;
      final response = await _vehicle.getVehicleByUserId(userid: userid);
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        if (list.isNotEmpty) {
          for (dynamic v in list) {
            if (validEnable) {
              if (v['enable']) {
                vehicles.add(VehicleModel.fromJson(v));
              }
              continue;
            }
            vehicles.add(VehicleModel.fromJson(v));
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
      notifyListeners();
    }
    return false;
  }

  Future<bool> getListVehicleConnector() async {
    try {
      listVehicleConnector.clear();
      final response = await _vehicle.getVehicleConnector();
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        debugPrint("${list.toList()}");
        if (list.isNotEmpty) {
          for (dynamic i in list) {
            listVehicleConnector.add(
              DropdownMenuItem(
                value: i['id'].toString(),
                child: Text(i['connector']),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
    return false;
  }

  Future<bool> getListVehicleType() async {
    try {
      listVehicleType.clear();
      listVehicleBrand.clear();
      listVehicleModel.clear();
      final response = await _vehicle.getVehicleType();
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        debugPrint("${list.toList()}");
        if (list.isNotEmpty) {
          for (dynamic i in list) {
            listVehicleType.add(
              DropdownMenuItem(
                value: i['id'].toString(),
                child: Text(i['type']),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
    return false;
  }

  Future<bool> getListVehicleBrand() async {
    try {
      listVehicleBrand.clear();
      listVehicleModel.clear();
      final vehicleType = int.parse(controllerVehicleType.text);
      final response = await _vehicle.getVehicleBrand(type: vehicleType);
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        debugPrint("${list.toList()}");
        if (list.isNotEmpty) {
          for (dynamic i in list) {
            listVehicleBrand.add(
              DropdownMenuItem(
                value: i['id'].toString(),
                child: Text(i['brand']),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
    return false;
  }

  Future<bool> getListVehicleModel() async {
    try {
      listVehicleModel.clear();
      final vehicleBrand = int.parse(controllerVehicleBrand.text);
      final response = await _vehicle.getVehicleModel(brandid: vehicleBrand);
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        debugPrint("${list.toList()}");
        if (list.isNotEmpty) {
          for (dynamic i in list) {
            listVehicleModel.add(
              DropdownMenuItem(
                value: i['id'].toString(),
                child: Text(i['model']),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
    return false;
  }

  Future<bool> registerNewVehicle() async {
    try {
      _loading.show();
      final int userid = _user.userLogin!.info.user.id;
      final vehicle = {
        "userid": userid,
        "plate": controllerVehiclePlateNumber.text.trim().toUpperCase(),
        "modelid": int.parse(controllerVehicleModel.text.trim()),
        "connectorid": int.tryParse(controllerVehicleConnector.text.trim()),
      };

      debugPrint(vehicle.toString());

      final response = await _vehicle.registerNewVehicle(body: vehicle);
      if (response.statusCode == 200) {
        clearAllFields();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<bool> updateEnableVehicle({
    required int id,
    required bool active,
  }) async {
    try {
      _loading.show();
      final Map body = {
        "plate": controllerVehiclePlateNumber.text.trim().toUpperCase(),
        "enable": active,
      };
      await Future.delayed(const Duration(seconds: 3));
      final response = await _vehicle.updateVehicle(id: id, body: body);
      if (response.statusCode == 200) {
        await getListVehicleByUserId();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<void> deleteVehicle({required int vehicleid}) async {
    try {
      _loading.show();

      await Future.delayed(const Duration(seconds: 1));
      final response = await _vehicle.deleteVehicle(id: vehicleid);
      if (response.statusCode == 200) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      await getListVehicleByUserId();
      _loading.hide();
    }
  }

  void clearAllFields() {
    listVehicleBrand.clear();
    listVehicleModel.clear();
    controllerVehicleBrand.clear();
    controllerVehicleConnector.clear();
    controllerVehicleModel.clear();
    controllerVehiclePlateNumber.clear();
    controllerVehicleType.clear();
  }
}

final vehicleProvider = ChangeNotifierProvider<VehicleProvider>(
  (ref) => VehicleProvider(ref: ref),
);
