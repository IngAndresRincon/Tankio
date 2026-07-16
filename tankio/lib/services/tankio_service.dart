import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/services/api_service.dart';

class TankioService {
  final ApiService _apiService;

  TankioService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> getDispenserPositionByCode({required String code}) {
    return _apiService.get(
      '/api/sandbox.tankio/v1/station/dispenser/position/$code',
    );
  }

  Future<Response<dynamic>> createProgramming({required Map body}) {
    return _apiService.post(
      '/api/sandbox.tankio/v1/programming/create',
      data: body,
    );
  }

  Future<Response<dynamic>> changeStatusProgramming({
    required String uuid,
    required Map body,
  }) {
    return _apiService.patch(
      '/api/sandbox.tankio/v1/programming/status/$uuid',
      data: body,
    );
  }
}

final tankioServiceProvider = Provider<TankioService>((ref) {
  return TankioService(apiService: ref.read(apiServiceProvider));
});
