import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/Model/payment_request.dart';
import 'package:tankio_webpage/Provider/loading.dart';
import 'package:tankio_webpage/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  Ref ref;
  PaymentProvider({required this.ref});

  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  PaymentService get _payment => ref.read(paymentServiceProvider);

  List<Map> listHistoryPayment = [];

  Future<void> getHistoryPayment() async {
    _loading.show();
    try {
      listHistoryPayment.clear();
      final response = await _payment.getHistoryPayment();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          for (dynamic e in data) {
            listHistoryPayment.add({
              "check": false,
              "payment": PaymentRequestModel.fromJson(e),
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

final paymentProvider = ChangeNotifierProvider<PaymentProvider>(
  (ref) => PaymentProvider(ref: ref),
);
