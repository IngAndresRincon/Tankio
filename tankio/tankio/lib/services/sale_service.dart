import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/services/api_service.dart';

class SaleService {
  final ApiService _apiService;

  SaleService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> getSaleByUserId({required int userid}) {
    return _apiService.get('/api/sandbox.tankio/v1/sale/$userid');
  }

  Future<Response<dynamic>> getInvoicBySaleId({required int saleid}) {
    return _apiService.get('/api/sandbox.tankio/v1/sale/invoice/$saleid');
  }

  Future<Response<dynamic>> updateInvoiceCustomerData({
    required int saleid,
    required Map payload,
  }) {
    return _apiService.patch(
      '/api/sandbox.tankio/v1/user/change-customer-details/$saleid',
      data: payload,
    );
  }
}

final saleServiceProvider = Provider<SaleService>((ref) {
  return SaleService(apiService: ref.read(apiServiceProvider));
});
