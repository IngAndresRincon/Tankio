import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/main.dart';
import 'package:tankio/models/balance_by_group_model.dart';
import 'package:tankio/models/programming_model.dart';
import 'package:tankio/models/user_authentication_response.dart';
import 'package:tankio/models/user_edit.dart';
import 'package:tankio/models/user_register.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/socketio.dart';
import 'package:tankio/services/secure_storage_service.dart';
import 'package:tankio/services/user_service.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:tankio/utils/enum.dart';
import 'package:tankio/widget/modal/status_modal.dart';

class UserProvider extends ChangeNotifier {
  final Ref ref;
  UserProvider({required this.ref});

  UserAuthentication? userLogin;

  List<DropdownMenuItem<String>> documentTypeList = const [
    DropdownMenuItem(value: '1', child: Text('NIT')),
    DropdownMenuItem(value: '2', child: Text('CC')),
    DropdownMenuItem(value: '3', child: Text('CE')),
  ];

  List<Map<String, dynamic>> activityFilterOptions = [
    {"id": 1, "label": "All", "active": true},
    {"id": 2, "label": "Fuel", "active": false},
    {"id": 3, "label": "EV", "active": false},
  ];

  //Context

  BuildContext? ctx = navigatorKey.currentContext;
  //Context

  //Biometric
  final LocalAuthentication biometriAuth = LocalAuthentication();
  final storage = SecureStorageService();
  bool _isAuthenticating = false;
  //Biometric

  //Controladores para login
  final controllerEmailLogin = TextEditingController();
  final controllerPasswordLogin = TextEditingController();
  //Controladores para login

  //Controladores cambiar contraseña
  final controllerNewPassword = TextEditingController();
  final controllerConfirmNewPassword = TextEditingController();

  bool atLeast8Characters = false;
  bool atLeastOneUppercaseLetter = false;
  bool atLeastOneNumber = false;
  bool atLeastOneSpecialCharacter = false;

  bool get isNewPasswordValid =>
      atLeast8Characters &&
      atLeastOneUppercaseLetter &&
      atLeastOneNumber &&
      atLeastOneSpecialCharacter;

  //Controladores cambiar contraseña

  //Controladores para registro

  final controllerRegisterName = TextEditingController();
  final controllerRegisterLastName = TextEditingController();
  final controllerRegisterEmail = TextEditingController();
  final controllerRegisterPassword = TextEditingController();
  final controllerRegisterConfirmPassword = TextEditingController();
  final controllerRegisterDocumentType = TextEditingController();
  final controllerRegisterDocumentNumber = TextEditingController();
  final controllerRegisterPhoneNumber = TextEditingController();

  //Controladores para registro

  //Controladores para perfil (profile)

  final controllerProfileName = TextEditingController();
  final controllerProfileLastName = TextEditingController();
  final controllerProfileEmail = TextEditingController();
  final controllerProfileDocumentType = TextEditingController();
  final controllerProfileDocumentNumber = TextEditingController();
  String? selectedDocumentType;
  final controllerProfilePhoneNumber = TextEditingController();
  //Controladores para perfil (profile)

  //Activity

  List<ProgrammingModel> programminglist = [];
  List<ProgrammingModel> programminglistfilter = [];
  String? _refreshToken;

  void activeFilterOption({required int id}) {
    for (var i = 0; i < activityFilterOptions.length; i++) {
      activityFilterOptions[i]['active'] = false;
      if (activityFilterOptions[i]['id'] == id) {
        activityFilterOptions[i]['active'] = true;
      }
    }

    if (id == 1) {
      programminglistfilter = List<ProgrammingModel>.from(programminglist);
    }
    if (id == 2) {
      programminglistfilter = programminglist
          .where((e) => e.systemId == 1)
          .toList();
    }
    if (id == 3) {
      programminglistfilter = programminglist
          .where((e) => e.systemId == 2)
          .toList();
    }
    notifyListeners();
  }

  //Activity

  UserService get _user => ref.read(userServiceProvider);
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  WSSocketIOProvider get _socket => ref.read(socketControllerProvider);

  void clearField() {
    controllerEmailLogin.clear();
    controllerPasswordLogin.clear();

    controllerNewPassword.clear();
    controllerConfirmNewPassword.clear();
    atLeast8Characters = false;
    atLeastOneUppercaseLetter = false;
    atLeastOneNumber = false;
    atLeastOneSpecialCharacter = false;

    controllerRegisterName.clear();
    controllerRegisterLastName.clear();
    controllerRegisterEmail.clear();
    controllerRegisterPassword.clear();
    controllerRegisterConfirmPassword.clear();
    controllerRegisterDocumentType.clear();
    controllerRegisterDocumentNumber.clear();
    controllerRegisterPhoneNumber.clear();

    controllerProfileName.clear();
    controllerProfileLastName.clear();
    controllerProfileEmail.clear();
    controllerProfilePhoneNumber.clear();
    controllerProfileDocumentNumber.clear();
  }

  Future<void> loadProfileData() async {
    _loading.show();
    try {
      selectedDocumentType = userLogin!.info.user.documentTypeId.toString();
      controllerProfileName.text = userLogin!.info.user.name;
      controllerProfileLastName.text = userLogin!.info.user.lastName;
      controllerProfileDocumentType.text = selectedDocumentType ?? '';
      controllerProfileDocumentNumber.text =
          userLogin!.info.user.documentNumber;
      controllerProfileEmail.text = userLogin!.info.user.email;
      controllerProfilePhoneNumber.text = userLogin!.info.user.phoneNumber;
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  Future<void> saveAuthenticationData(Map<String, dynamic> data) async {
    userLogin = UserAuthentication.fromJson(data);
    await getRecentActivityByuser();
    await saveTokens();
    _socket.initConnectSocket();
    clearField();
  }

  Future<bool> passwordRecovery() async {
    _loading.show();
    try {
      await Future.delayed(const Duration(seconds: 3));
      final response = await _user.passwordRecovery(
        email: controllerEmailLogin.text.trim(),
      );
      if (response.statusCode == 200) {
        controllerEmailLogin.clear();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<bool> userAuthentication() async {
    _loading.show();
    try {
      final response = await _user.authentication(
        email: controllerEmailLogin.text.toLowerCase(),
        password: controllerPasswordLogin.text,
      );
      if (response.statusCode == 200) {
        await saveAuthenticationData(response.data['data']);
        return true;
      }

      AppStatusModal.show(
        context: ctx!,
        type: AppModalType.error,
        title: "Error",
        message: response.statusCode == 404
            ? response.data.toString()
            : response.data['message'],
        primaryText: "Continue",
        dismissible: false,
        onPrimaryPressed: () => Navigator.pop(ctx!),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<bool> userRegister() async {
    try {
      _loading.show();
      final register = UserRegisterModel(
        name: controllerRegisterName.text,
        lastname: controllerRegisterLastName.text,
        email: controllerRegisterEmail.text.toLowerCase(),
        password: controllerRegisterPassword.text,
        documenttype: int.parse(controllerRegisterDocumentType.text),
        documentnumber: controllerRegisterDocumentNumber.text,
        phonenumber: controllerRegisterPhoneNumber.text,
      );

      final response = await _user.register(user: register);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<bool> userEdit() async {
    try {
      _loading.show();
      final edit = UserEditModel(
        name: controllerProfileName.text,
        lastname: controllerProfileLastName.text,
        email: controllerProfileEmail.text,
        documenttype: int.parse(controllerProfileDocumentType.text),
        documentnumber: controllerProfileDocumentNumber.text,
        phonenumber: controllerProfilePhoneNumber.text,
      );
      await Future.delayed(const Duration(seconds: 2));
      final response = await _user.edit(
        userid: userLogin!.info.user.id,
        user: edit,
      );
      if (response.statusCode == 200) {
        final Map user = response.data['data'];
        userLogin!.info.user.name = user['name'];
        userLogin!.info.user.lastName = user['last_name'];
        userLogin!.info.user.email = user['email'];
        userLogin!.info.user.phoneNumber = user['phone_number'];
        userLogin!.info.user.documentNumber = user['document_number'];
        userLogin!.info.user.documentTypeId = user['document_type_id'];
        clearField();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
    return false;
  }

  bool validCurrentPassword(String pwd) {
    final hash = userLogin?.info.user.keyHash;
    if (hash == null || hash.isEmpty) {
      return false;
    }

    if (BCrypt.checkpw(pwd, hash)) {
      return true;
    }
    return false;
  }

  bool validConfirmPassword() {
    return controllerConfirmNewPassword.text == controllerNewPassword.text;
  }

  void validNewPassword(String pwd) {
    controllerConfirmNewPassword.clear();
    atLeast8Characters = pwd.length >= 8;
    atLeastOneUppercaseLetter = RegExp(r'[A-Z]').hasMatch(pwd);
    atLeastOneNumber = RegExp(r'\d').hasMatch(pwd);
    atLeastOneSpecialCharacter = RegExp(r'[^\w\s]').hasMatch(pwd);

    notifyListeners();
  }

  Future<bool> changePassword() async {
    _loading.show();

    try {
      final id = userLogin!.info.user.id;

      Map body = {"password": controllerNewPassword.text.trim()};
      final response = await _user.changePassword(body: body, userid: id);
      if (response.statusCode == 200) {
        userLogin!.info.user.keyHash = response.data['data']['key_hash'];
        return true;
      }
    } catch (e) {
      e.toString();
    } finally {
      notifyListeners();
      _loading.hide();
    }

    return false;
  }

  Future<void> saveBiometricSettings({required bool enable}) async {
    _loading.show();
    try {
      await storage.saveBiometricEnable(enable);
      await Future.delayed(const Duration(seconds: 2));
      if (!enable) return;
      await saveTokens();
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
  }

  Future<void> saveTokens() async {
    await storage.saveSessionSnapshot(userLogin!);
    await storage.saveTokens(
      accessToken: userLogin!.token,
      refreshToken: userLogin!.refreshToken,
    );
  }

  Future<bool> readBiometricEnable() async {
    return await storage.readBiometricEnable();
  }

  Future<bool> biometricAuthenticate() async {
    _loading.show();
    try {
      if (_isAuthenticating) return false;
      _isAuthenticating = true;
      bool biometricEnable = await storage.readBiometricEnable();
      if (!biometricEnable) {
        debugPrint(
          "La configuración de seguridad biómetrica no está habilitada",
        );
        return false;
      }

      final canCheckBiometrics = await biometriAuth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        debugPrint("Biometric not valid");
        return false;
      }

      final authenticated = await biometriAuth.authenticate(
        localizedReason: 'Autentícate para ingresar a la app',
        options: const AuthenticationOptions(
          biometricOnly: false,
          sensitiveTransaction: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (!authenticated) {
        return false;
      }

      _refreshToken = await storage.getRefreshToken();
      if (_refreshToken == null || _refreshToken!.isEmpty) {
        debugPrint("Session biometric is not valid");
        return false;
      }
      return true;
      //return await biometricLogin(_refreshToken!);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isAuthenticating = false;
      _loading.hide();
    }
    return false;
  }

  Future<bool> biometricLogin() async {
    _loading.show();
    try {
      final cachedSession = await storage.readSessionSnapshot();
      if (cachedSession == null) {
        debugPrint('no hay datos de sesión');
        return false;
      }

      final response = await _user.validTokenRefresh(token: _refreshToken!);
      if (response.statusCode == 200) {
        await saveAuthenticationData(response.data['data']);
        return true;
      } else {
        AppStatusModal.show(
          context: ctx!,
          type: AppModalType.error,
          title: "Error",
          message: response.data['message'],
          primaryText: "Continue",
          dismissible: false,
          onPrimaryPressed: () => Navigator.pop(ctx!),
        );
      }
      // if (isValid) {
      //   await loadHomeDependencies();
      //   navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //     '/index',
      //     (route) => false,
      //   );
      // } else {
      //   await NotificationProvider.mainNotification(
      //     "E1",
      //     "La sesión biométrica expiró. Ingresa nuevamente con correo y contraseña.",
      //   );
      // }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
      notifyListeners();
    }
    return false;
  }

  Future<bool> deleteAccount() async {
    _loading.show();
    try {
      final id = userLogin!.info.user.id;
      final response = await _user.deleteAccount(userid: id);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<void> clearSessionAndLogout({bool preserveBiometric = true}) async {
    try {
      _socket.disconnect();
      if (preserveBiometric) {
        await storage.clearAccessToken();
      } else {
        await storage.clear();
      }
      userLogin = null;
      clearField();
      //notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> getStatusTYC() async {
    _loading.show();
    try {
      final id = userLogin!.info.user.id;
      final response = await _user.getStatusTYC(userid: id);
      if (response.statusCode == 200) {
        final isAgree = response.data['data']['user_agree'];
        return isAgree;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<bool> registerTYC({required bool isAgree}) async {
    _loading.show();
    try {
      final Map body = {"userid": userLogin!.info.user.id, "isagreed": isAgree};
      await Future.delayed(const Duration(seconds: 2));

      final response = await _user.registerTYC(body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  Future<void> getProgrammingActivityByUser() async {
    _loading.show();
    try {
      final l10n = AppLocalizations.of(ctx!)!;
      programminglist.clear();
      programminglistfilter.clear();
      final response = await _user.getProgrammingByUser(
        userid: userLogin!.info.user.id,
      );
      if (response.statusCode == 200) {
        bool showRegisteredInfo = false;
        debugPrint(jsonEncode(response.data['data']));
        final List<dynamic> list = response.data['data'];
        if (list.isNotEmpty) {
          for (dynamic e in list) {
            if (e['programming_status_id'] == 0) {
              showRegisteredInfo = true;
              debugPrint("Hay una programaicón pendiente por autorización");
            }
            programminglist.add(ProgrammingModel.fromJson(e));
          }
          if (showRegisteredInfo) {
            AppStatusModal.show(
              context: ctx!,
              type: AppModalType.success,
              title: l10n.programmingTitle,
              message: l10n.programmingPendingAuthorizationMessage,
              primaryText: l10n.continueButton,
              onPrimaryPressed: () => Navigator.pop(ctx!),
            );
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      programminglistfilter = programminglist;
      _loading.hide();
      notifyListeners();
    }
  }

  Future<void> getRecentActivityByuser() async {
    _loading.show();
    try {
      programminglist.clear();
      final response = await _user.getActivityByUser(
        userid: userLogin!.info.user.id,
      );
      if (response.statusCode == 200) {
        debugPrint(jsonEncode(response.data['data']));
        final List<dynamic> list = response.data['data'];
        if (list.isNotEmpty) {
          for (dynamic e in list) {
            programminglist.add(ProgrammingModel.fromJson(e));
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
      notifyListeners();
    }
  }

  Future<void> notifyUpdateActivityProgramming(Map item) async {
    try {
      _loading.show();
      await Future.delayed(const Duration(seconds: 3));
      for (ProgrammingModel i in programminglist) {
        if (i.programmingId == item['id']) {
          i.programmingStatusId = item['programming_status_id'];
          debugPrint(jsonEncode(i));
        }
      }

      programminglistfilter = programminglist;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  void changeUserBalanceDefault(BalanceByGroupModel newBalance) {
    userLogin!.info.balance = newBalance;
    notifyListeners();
  }
}

final userProvider = ChangeNotifierProvider<UserProvider>(
  (ref) => UserProvider(ref: ref),
);
