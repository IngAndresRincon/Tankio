import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/models/sale_model.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/services/sale_service.dart';

class SaleProvider extends ChangeNotifier {
  final Ref ref;

  SaleProvider({required this.ref});

  List<SaleModel> listSale = [];
  List<SaleModel> listSaleFilter = [];
  UserProvider get _user => ref.read(userProvider);
  SaleService get _sale => ref.read(saleServiceProvider);
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);

  List<Map<String, dynamic>> activityFilterOptions = [
    {"id": 1, "label": "All", "active": true},
    {"id": 2, "label": "Fuel", "active": false},
    {"id": 3, "label": "EV", "active": false},
  ];
  void activeFilterOption({required int id}) {
    for (var i = 0; i < activityFilterOptions.length; i++) {
      activityFilterOptions[i]['active'] = false;
      if (activityFilterOptions[i]['id'] == id) {
        activityFilterOptions[i]['active'] = true;
      }
    }

    if (id == 1) {
      listSaleFilter = List<SaleModel>.from(listSale);
    }
    if (id == 2) {
      listSaleFilter = listSale.where((e) => e.systemId == 1).toList();
    }
    if (id == 3) {
      listSaleFilter = listSale.where((e) => e.systemId == 2).toList();
    }
    notifyListeners();
  }

  Future<void> getSaleByUserId() async {
    _loading.show();
    try {
      listSale.clear();
      listSaleFilter.clear();
      final id = _user.userLogin!.info.user.id;
      final response = await _sale.getSaleByUserId(userid: id);
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        if (list.isNotEmpty) {
          for (dynamic e in list) {
            listSale.add(SaleModel.fromJson(e));
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      listSaleFilter = listSale;
      notifyListeners();
      _loading.hide();
    }
  }
}

final saleProvider = ChangeNotifierProvider<SaleProvider>(
  (ref) => SaleProvider(ref: ref),
);
