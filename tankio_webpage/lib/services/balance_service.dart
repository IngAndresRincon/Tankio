import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/services/api_service.dart';

class BalanceService {
  final ApiService _apiService;

  BalanceService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> getListUserBalanceGroup() {
    return _apiService.get('/api/sandbox.tankio/v1/web/balance');
  }
}

final balanceServiceProvider = Provider<BalanceService>((ref) {
  return BalanceService(apiService: ref.read(apiServiceProvider));
});
