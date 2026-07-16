import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/services/app_config.dart';

class ApiService {
  final Dio _dio;
  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 1),
          headers: const {
            'Content-Type': 'application/json',
            'x-api-key': AppConfig.apiKey,
          },
          validateStatus: (status) =>
              status != null && status >= 100 && status <= 599,
        ),
      );

  Future<Response<dynamic>> get(String endpoint) => _dio.get(endpoint);

  Future<Response<dynamic>> post(String endpoint, {Object? data}) =>
      _dio.post(endpoint, data: data);

  Future<Response<dynamic>> put(String endpoint, {Object? data}) =>
      _dio.put(endpoint, data: data);

  Future<Response<dynamic>> patch(String endpoint, {Object? data}) =>
      _dio.patch(endpoint, data: data);

  Future<Response<dynamic>> delete(String endpoint, {Object? data}) =>
      _dio.delete(endpoint, data: data);
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
