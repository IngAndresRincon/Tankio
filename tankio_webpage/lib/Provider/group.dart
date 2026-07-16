import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/Model/group.dart';
import 'package:tankio_webpage/Provider/loading.dart';
import 'package:tankio_webpage/services/group_service.dart';

class GroupProvider extends ChangeNotifier {
  Ref ref;
  GroupProvider({required this.ref});

  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  GroupService get _group => ref.read(groupServiceProvider);

  List<Map<String, dynamic>> listGroups = [];

  Future<void> getListGroups() async {
    _loading.show();
    try {
      listGroups.clear();
      notifyListeners();
      final response = await _group.getListGroups();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          for (dynamic e in data) {
            listGroups.add({
              "check": false,
              "group": GroupModel.fromJson(e as Map<String, dynamic>),
            });
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
}

final groupProvider = ChangeNotifierProvider<GroupProvider>(
  (ref) => GroupProvider(ref: ref),
);
