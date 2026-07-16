import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/Model/user_group_balance.dart';
import 'package:tankio_webpage/Provider/loading.dart';
import 'package:tankio_webpage/services/balance_service.dart';

class BalanceProvider extends ChangeNotifier {
  Ref ref;
  BalanceProvider({required this.ref});

  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  BalanceService get _balance => ref.read(balanceServiceProvider);

  List<Map<String, dynamic>> listBalancesUser = [];

  Future<void> getListUserBalanceGroup() async {
    _loading.show();
    try {
      listBalancesUser.clear();
      notifyListeners();
      final response = await _balance.getListUserBalanceGroup();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          for (dynamic e in data) {
            listBalancesUser.add({
              "check": false,
              "balance": AppUserGroupBalanceModel.fromJson(
                e as Map<String, dynamic>,
              ),
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

final balanceProvider = ChangeNotifierProvider<BalanceProvider>(
  (ref) => BalanceProvider(ref: ref),
);
