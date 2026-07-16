import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/services/api_service.dart';

class VehicleService {
  final ApiService _apiService;

  final String baseUrl = "/api/sandbox.tankio/v1/vehicle/";

  VehicleService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<dynamic>> getVehicleByUserId({required int userid}) {
    return _apiService.get('$baseUrl$userid');
  }

  Future<Response<dynamic>> getVehicleConnector() {
    return _apiService.get('${baseUrl}connector');
  }

  Future<Response<dynamic>> getVehicleType() {
    return _apiService.get('${baseUrl}type');
  }

  Future<Response<dynamic>> getVehicleBrand({required int type}) {
    return _apiService.get('${baseUrl}brand/$type');
  }

  Future<Response<dynamic>> getVehicleModel({required int brandid}) {
    return _apiService.get('${baseUrl}model/$brandid');
  }

  Future<Response<dynamic>> registerNewVehicle({required Map body}) {
    return _apiService.post('${baseUrl}register', data: body);
  }

  Future<Response<dynamic>> updateVehicle({
    required int id,
    required Map body,
  }) {
    return _apiService.patch('${baseUrl}edit/$id', data: body);
  }

  Future<Response<dynamic>> deleteVehicle({required int id}) {
    return _apiService.delete('${baseUrl}delete/$id');
  }
}

final vehicleServiceProvider = Provider<VehicleService>((ref) {
  return VehicleService(apiService: ref.read(apiServiceProvider));
});
