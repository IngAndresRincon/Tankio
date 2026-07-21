import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/models/invoice_model.dart';
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
  InvoiceModel? invoice;

  List<DropdownMenuItem<String>> documentTypeList = const [
    DropdownMenuItem(value: '1', child: Text('NIT')),
    DropdownMenuItem(value: '2', child: Text('CC')),
    DropdownMenuItem(value: '3', child: Text('CE')),
  ];

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

  final controllerInvoiceName = TextEditingController();
  final controllerInvoiceLastName = TextEditingController();
  final controllerInvoiceEmail = TextEditingController();
  final controllerInvoiceDocumentType = TextEditingController();
  final controllerInvoiceDocumentNumber = TextEditingController();
  String? selectedDocumentType;
  final controllerInvoicePhoneNumber = TextEditingController();

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

  Future<void> getInvoiceInformationBySale({required int saleid}) async {
    try {
      invoice = null;
      _loading.show();
      final response = await _sale.getInvoicBySaleId(saleid: saleid);
      if (response.statusCode == 200) {
        debugPrint(jsonEncode(response.data));
        invoice = InvoiceModel.fromJson(response.data['data']);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
      notifyListeners();
    }
  }

  void loadInvoiceCustomerData() {
    try {
      if (invoice != null) {
        controllerInvoiceName.text = invoice!.userPayload.name;
        controllerInvoiceLastName.text = invoice!.userPayload.lastName;
        controllerInvoiceEmail.text = invoice!.userPayload.email;
        controllerInvoicePhoneNumber.text = invoice!.userPayload.phoneNumber;
        controllerInvoiceDocumentNumber.text =
            invoice!.userPayload.documentNumber;
        selectedDocumentType = invoice!.userPayload.documentTypeId.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateInvoiceCustomerData() async {
    _loading.show();
    try {
      final DropdownMenuItem documentLabel = documentTypeList.firstWhere(
        (e) => e.value == selectedDocumentType,
      );

      final Map payload = {
        "name": controllerInvoiceName.text.trim(),
        "email": controllerInvoiceEmail.text.trim(),
        "user_id": _user.userLogin!.info.user.id,
        "document": (documentLabel.child as Text).data ?? '',
        "last_name": controllerInvoiceLastName.text.trim(),
        "phone_number": controllerInvoicePhoneNumber.text.trim(),
        "document_number": controllerInvoiceDocumentNumber.text.trim(),
        "document_type_id": int.parse(selectedDocumentType ?? "0"),
        "document_type_code": "31", // se reemplaza en backend
      };

      final response = await _sale.updateInvoiceCustomerData(
        saleid: invoice!.saleId,
        payload: payload,
      );
      if (response.statusCode == 200) {
        debugPrint(jsonEncode(response.data['data']));
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }
}

final saleProvider = ChangeNotifierProvider<SaleProvider>(
  (ref) => SaleProvider(ref: ref),
);
