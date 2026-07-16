import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/services/api_service.dart';

class BalanceService {
  final ApiService _apiService;

  BalanceService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> getBalanceMovementsByUserId({required int userid}) {
    return _apiService.get('/api/sandbox.tankio/v1/balance/movements/$userid');
  }

  Future<Response<dynamic>> getBalanceGroupUserId({required int userid}) {
    return _apiService.get('/api/sandbox.tankio/v1/balance/group/$userid');
  }

  Future<Response<dynamic>> getInformationBalance({required int balanceid}) {
    return _apiService.get('/api/sandbox.tankio/v1/balance/$balanceid');
  }
}

final balanceServiceProvider = Provider<BalanceService>((ref) {
  return BalanceService(apiService: ref.read(apiServiceProvider));
});
