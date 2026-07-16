import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/main.dart';
import 'package:tankio/models/balance_by_group_model.dart';
import 'package:tankio/models/balance_movement_model.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/balance_service.dart';

class BalanceProvider extends ChangeNotifier {
  final Ref ref;

  BalanceProvider({required this.ref});

  List<BalanceMovementModel> listMovements = [];
  List<BalanceByGroupModel> balanceGroup = [];
  BalanceByGroupModel? selectedBalanceGroup;
  UserProvider get _user => ref.read(userProvider);
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  BalanceService get _balance => ref.read(balanceServiceProvider);
  BuildContext? context = navigatorKey.currentContext;
  final size = MediaQuery.of(navigatorKey.currentContext!).size;

  Future<void> getBalanceMovementsByUserId() async {
    _loading.show();
    try {
      listMovements.clear();
      final response = await _balance.getBalanceMovementsByUserId(
        userid: _user.userLogin!.info.user.id,
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        debugPrint(jsonEncode(list));
        if (list.isNotEmpty) {
          for (dynamic i in list) {
            listMovements.add(BalanceMovementModel.fromJson(i));
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

  Future<bool> getBalanceGroupByUserId() async {
    _loading.show();
    try {
      balanceGroup.clear();
      final response = await _balance.getBalanceGroupUserId(
        userid: _user.userLogin!.info.user.id,
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        debugPrint(jsonEncode(list));
        if (list.isNotEmpty) {
          for (dynamic i in list) {
            balanceGroup.add(BalanceByGroupModel.fromJson(i));
          }
        }
        if (balanceGroup.isNotEmpty) {
          final currentSelectedId = selectedBalanceGroup?.balanceId;
          selectedBalanceGroup = balanceGroup.firstWhere(
            (item) => item.balanceId == currentSelectedId,
            orElse: () => balanceGroup.first,
          );
        } else {
          selectedBalanceGroup = null;
        }
        return balanceGroup.isNotEmpty;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      _loading.hide();
    }

    return false;
  }

  void selectBalanceGroupById(int balanceId) {
    for (final group in balanceGroup) {
      if (group.balanceId == balanceId) {
        selectedBalanceGroup = group;
        notifyListeners();
        return;
      }
    }
  }

  Future<void> updateInformationBalance() async {
    _loading.show();
    try {
      if (_user.userLogin!.info.balance == null) {
        showCupertinoModalPopup(
          context: context!,
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Center(
              child: Consumer(
                builder: (context, ref, child) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    width: size.width * 0.8,
                    height: size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber,
                            size: size.width * 0.2,
                          ),

                          Text(
                            l10n.balanceStationHintLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.041,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 10),
                          Icon(
                            Icons.point_of_sale_rounded,
                            color: Colors.black,
                            size: size.width * 0.08,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );

        return;
      }

      final balanceid = _user.userLogin!.info.balance!.balanceId;
      final response = await _balance.getInformationBalance(
        balanceid: balanceid,
      );
      if (response.statusCode == 200) {
        selectedBalanceGroup = BalanceByGroupModel.fromJson(
          response.data['data'],
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setUserBalance();
      _loading.hide();
    }
  }

  void setUserBalance() {
    final group = selectedBalanceGroup;
    if (group == null) return;
    _user.changeUserBalanceDefault(group);
  }
}

final balanceProvider = ChangeNotifierProvider<BalanceProvider>(
  (ref) => BalanceProvider(ref: ref),
);
