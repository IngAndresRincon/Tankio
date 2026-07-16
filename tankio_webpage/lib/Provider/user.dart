// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/Model/login_user.dart';
import 'package:tankio_webpage/Model/navbar.dart';
import 'package:tankio_webpage/Model/user_group_balance.dart';
import 'package:tankio_webpage/Provider/loading.dart';
import 'package:tankio_webpage/services/user_service.dart';

class LoginProvider extends ChangeNotifier {
  Ref ref;
  LoginProvider({required this.ref});

  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  UserService get _userService => ref.read(userServiceProvider);

  // Controladores Login
  final controllerLoginEmail = TextEditingController();
  final controllerLoginPassword = TextEditingController();
  // Controladores Login

  // Controladores nuevo usuario
  String defaultRole = '1';

  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  List<DropdownMenuItem<String>> listRol = [
    DropdownMenuItem(value: "1", child: Text("Super Administrador")),
    DropdownMenuItem(value: "2", child: Text("Administrador")),
    DropdownMenuItem(value: "3", child: Text("Usuario")),
    DropdownMenuItem(value: "4", child: Text("Operador")),
  ];

  List<DropdownMenuItem<String>> listGroupsUser = [];

  // Controladores nuevo usuario

  LoginUser? login;
  List<Map> listUser = [];
  List<Map<String, dynamic>> listBalancesAppUser = [];

  final List<NavItem> navItems = const [
    NavItem(
      icon: Icons.dashboard_rounded,
      title: 'Dashboard',
      subtitle: 'Resumen general',
      rolList: [1, 2],
    ),
    NavItem(
      icon: Icons.ev_station_rounded,
      title: 'Grupos',
      subtitle: 'Disponibilidad y estado',
      rolList: [1, 2],
    ),
    NavItem(
      icon: Icons.people_alt_rounded,
      title: 'Usuarios Web',
      subtitle: 'Gestion de usuarios web',
      rolList: [1],
    ),
    NavItem(
      icon: Icons.people_alt_rounded,
      title: 'Usuarios Tankio',
      subtitle: 'Gestion de usuarios app',
      rolList: [1],
    ),
    NavItem(
      icon: Icons.people_alt_rounded,
      title: 'Saldo',
      subtitle: 'Gestion de saldos por grupo',
      rolList: [1],
    ),

    NavItem(
      icon: Icons.receipt_long_rounded,
      title: 'Pagos',
      subtitle: 'Movimientos recientes',
      rolList: [1, 2],
    ),
    NavItem(
      icon: Icons.bar_chart_rounded,
      title: 'Reportes',
      subtitle: 'Metricas y analitica',
      rolList: [1, 2, 3],
    ),
    NavItem(
      icon: Icons.settings_rounded,
      title: 'Ajustes',
      subtitle: 'Configuracion del sistema',
      rolList: [1],
    ),
  ];

  List<NavItem> navItemsActive = [];

  Future<bool> loginUser() async {
    _loading.show();
    try {
      final response = await _userService.authentication(
        email: controllerLoginEmail.text,
        password: controllerLoginPassword.text,
      );
      if (response.statusCode == 200) {
        login = LoginUser.fromJson(response.data['data']);
        if (login!.groups.isNotEmpty) {
          listGroupsUser.clear();
          for (LoginUserGroup i in login!.groups) {
            listGroupsUser.add(
              DropdownMenuItem(
                value: i.groupId.toString(),
                child: Text("${i.companyName}-${i.groupName}"),
              ),
            );
          }
        }
        debugPrint("Login successful: ${response.data}");
        navItemsActive = navItems
            .where((item) => item.rolList.contains(login!.rolId))
            .toList();
        return true;
      } else {
        debugPrint("Login failed: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      debugPrint("Login error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      _loading.hide();
    }

    return false;
  }

  void setUserDetails(LoginUser user) {
    controllerFirstName.text = user.name;
    controllerLastName.text = user.lastName;
    controllerEmail.text = user.email;
    controllerPhone.text = user.phoneNumber;
    controllerPassword.text = user.password;
    defaultRole = user.rolId.toString();
  }

  Future<bool> getWebUsers() async {
    _loading.show();
    try {
      if (login == null) {
        debugPrint('No hay sesion activa. No se pueden cargar usuarios.');
        return false;
      }
      await Future.delayed(const Duration(seconds: 1));

      listUser.clear();
      final response = await _userService.listUsersByLoginUserId(id: login!.id);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          for (dynamic i in data) {
            listUser.add({
              "check": false,
              "user": LoginUser.fromJson(i as Map<String, dynamic>),
            });
          }
        }
        notifyListeners();
        return true;
      } else {
        debugPrint(
          "Users load failed: ${response.statusCode} - ${response.data}",
        );
      }
    } catch (e) {
      debugPrint("Users load error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      _loading.hide();
    }

    return false;
  }

  Future<bool> createWebUser() async {
    _loading.show();
    try {
      final payload = {
        "rolid": int.parse(defaultRole),
        "name": controllerFirstName.text.trim(),
        "lastname": controllerLastName.text.trim(),
        "phonenumber": controllerPhone.text.trim(),
        "email": controllerEmail.text.trim(),
        "password": controllerPassword.text.trim(),
      };

      final response = await _userService.createUser(payload: payload);
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Register user failed");
      }
    } catch (e) {
      debugPrint("Users load error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      _loading.hide();
    }

    return false;
  }

  Future<bool> editWebUser({required int id}) async {
    _loading.show();
    try {
      final payload = {
        "rolid": int.parse(defaultRole),
        "name": controllerFirstName.text.trim(),
        "lastname": controllerLastName.text.trim(),
        "phonenumber": controllerPhone.text.trim(),
        "email": controllerEmail.text.trim(),
        "password": controllerPassword.text.trim(),
      };

      final response = await _userService.editUser(id: id, payload: payload);
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Register user failed");
      }
    } catch (e) {
      debugPrint("Users load error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      _loading.hide();
    }

    return false;
  }

  Future<void> getListAppUsers() async {
    _loading.show();
    try {
      listBalancesAppUser.clear();
      notifyListeners();
      final response = await _userService.getListUserApp();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          for (dynamic e in data) {
            listBalancesAppUser.add({
              "check": false,
              "users": AppUserGroupBalanceModel.fromJson(
                e as Map<String, dynamic>,
              ),
            });
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
}

final userProvider = ChangeNotifierProvider<LoginProvider>(
  (ref) => LoginProvider(ref: ref),
);
