import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/services/api_service.dart';

class UserService {
  final ApiService _apiService;

  UserService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> authentication({
    required String email,
    required String password,
  }) {
    return _apiService.post(
      '/api/sandbox.tankio/v1/web/user/authentication',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response<dynamic>> listUsersByLoginUserId({required int id}) {
    return _apiService.get('/api/sandbox.tankio/v1/web/user/users/$id');
  }

  Future<Response<dynamic>> createUser({required Map payload}) {
    return _apiService.post('/api/sandbox.tankio/v1/web/user', data: payload);
  }

  Future<Response<dynamic>> editUser({required int id, required Map payload}) {
    return _apiService.patch(
      '/api/sandbox.tankio/v1/web/user/$id',
      data: payload,
    );
  }

  Future<Response<dynamic>> getListUserApp() {
    return _apiService.get('/api/sandbox.tankio/v1/web/user/tankio-app');
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(apiService: ref.read(apiServiceProvider));
});
