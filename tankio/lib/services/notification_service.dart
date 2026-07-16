import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/services/api_service.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService({required ApiService apiService})
    : _apiService = apiService;

  Future<Response<dynamic>> notifications({required int userid}) {
    return _apiService.get('/api/sandbox.tankio/v1/notification/$userid');
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(apiService: ref.read(apiServiceProvider));
});
