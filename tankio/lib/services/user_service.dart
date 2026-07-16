import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/models/user_edit.dart';
import 'package:tankio/models/user_register.dart';
import 'package:tankio/services/api_service.dart';

class UserService {
  final ApiService _apiService;

  UserService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> authentication({
    required String email,
    required String password,
  }) {
    return _apiService.post(
      '/api/sandbox.tankio/v1/user/authentication',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response<dynamic>> register({required UserRegisterModel user}) {
    return _apiService.post('/api/sandbox.tankio/v1/user/register', data: user);
  }

  Future<Response<dynamic>> edit({
    required UserEditModel user,
    required int userid,
  }) {
    return _apiService.patch(
      '/api/sandbox.tankio/v1/user/edit/$userid',
      data: user,
    );
  }

  Future<Response<dynamic>> getStatusTYC({required int userid}) {
    return _apiService.get(
      '/api/sandbox.tankio/v1/user/terms&conditions/$userid',
    );
  }

  Future<Response<dynamic>> registerTYC({required Map body}) {
    return _apiService.post(
      '/api/sandbox.tankio/v1/user/terms&conditions',
      data: body,
    );
  }

  Future<Response<dynamic>> changePassword({
    required Map body,
    required int userid,
  }) {
    return _apiService.patch(
      '/api/sandbox.tankio/v1/user/change-password/$userid',
      data: body,
    );
  }

  Future<Response<dynamic>> validTokenRefresh({required String token}) {
    return _apiService.post(
      '/api/sandbox.tankio/v1/user/token-refresh',
      data: {"token": token},
    );
  }

  Future<Response<dynamic>> getProgrammingByUser({required int userid}) {
    return _apiService.get('/api/sandbox.tankio/v1/programming/$userid');
  }

  Future<Response<dynamic>> getActivityByUser({required int userid}) {
    return _apiService.get(
      '/api/sandbox.tankio/v1/programming/activity/$userid',
    );
  }

  Future<Response<dynamic>> passwordRecovery({required String email}) {
    return _apiService.post(
      '/api/sandbox.tankio/v1/user/password-recovery/$email',
    );
  }

  Future<Response<dynamic>> deleteAccount({required int userid}) {
    return _apiService.delete(
      '/api/sandbox.tankio/v1/user/delete-account/$userid',
    );
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(apiService: ref.read(apiServiceProvider));
});
