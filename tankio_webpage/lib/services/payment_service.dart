import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/services/api_service.dart';

class PaymentService {
  final ApiService _apiService;

  PaymentService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> getHistoryPayment() {
    return _apiService.get('/api/sandbox.tankio/v1/web/payment/history');
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(apiService: ref.read(apiServiceProvider));
});
