import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/models/notification_model.dart';
import 'package:tankio/provider/audio.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final Ref ref;

  NotificationProvider({required this.ref});

  bool hasNewNotification = false;

  List<NotificationModel> listNotification = [];
  UserProvider get _user => ref.read(userProvider);
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  NotificationService get _notification =>
      ref.read(notificationServiceProvider);

  Future<void> getNotificationsByUserId() async {
    _loading.show();
    try {
      hasNewNotification = false;
      listNotification.clear();
      await Future.delayed(const Duration(seconds: 3));
      final response = await _notification.notifications(
        userid: _user.userLogin!.info.user.id,
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        debugPrint(jsonEncode(list));
        if (list.isNotEmpty) {
          for (dynamic i in list) {
            listNotification.add(NotificationModel.fromJson(i));
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  Future<void> deleteItemNotificationFromList(int deleteid) async {
    _loading.show();
    try {
      await Future.delayed(const Duration(seconds: 2));
      listNotification.removeWhere((e) => e.id == deleteid);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }
  }

  void reportActiveNotifications(Map data) {
    hasNewNotification = true;
    ref.read(audioControllerProvider).playAudio();
    debugPrint(jsonEncode(data));
    notifyListeners();
  }
}

final notificationProvider = ChangeNotifierProvider<NotificationProvider>(
  (ref) => NotificationProvider(ref: ref),
);
