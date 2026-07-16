import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/services/api_service.dart';

class StationService {
  final ApiService _apiService;

  StationService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> stations() {
    return _apiService.get('/api/sandbox.tankio/v1/station/');
  }

  Future<Response<dynamic>> paymentgatewaystation() {
    return _apiService.get('/api/sandbox.tankio/v1/station/payment-gateway/');
  }

  Future<Response<dynamic>> createpaymentgateway({required Map payload}) {
    return _apiService.post(
      '/api/sandbox.tankio/v1/payment-gateway/register',
      data: payload,
    );
  }

  Future<Response<dynamic>> findDispenserPaymentGatewayByPositionCode({
    required String code,
  }) {
    return _apiService.get(
      '/api/sandbox.tankio/v1/station/dispenser/payment-gateway/$code',
    );
  }
}

final stationServiceProvider = Provider<StationService>((ref) {
  return StationService(apiService: ref.read(apiServiceProvider));
});
