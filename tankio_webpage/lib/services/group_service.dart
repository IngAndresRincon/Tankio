import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/services/api_service.dart';

class GroupService {
  final ApiService _apiService;

  GroupService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> getListGroups() {
    return _apiService.get('/api/sandbox.tankio/v1/web/group');
  }

  Future<Response<dynamic>> createGroup({required Map payload}) {
    return _apiService.post('/api/sandbox.tankio/v1/web/user', data: payload);
  }

  Future<Response<dynamic>> editGroup({required int id, required Map payload}) {
    return _apiService.patch(
      '/api/sandbox.tankio/v1/web/user/$id',
      data: payload,
    );
  }
}

final groupServiceProvider = Provider<GroupService>((ref) {
  return GroupService(apiService: ref.read(apiServiceProvider));
});
