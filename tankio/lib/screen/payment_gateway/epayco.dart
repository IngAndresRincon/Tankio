import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tankio/provider/station.dart';
import 'package:tankio/provider/user.dart';

class EpaycoCheckoutPage extends ConsumerStatefulWidget {
  const EpaycoCheckoutPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebPageState();
}

class _WebPageState extends ConsumerState<EpaycoCheckoutPage> {
  String? htmlContent;

  @override
  void initState() {
    super.initState();
    loadFile();
  }

  Future<void> loadFile() async {
    String file = await rootBundle.loadString('assets/epayco.html');
    final user = ref.read(userProvider);
    final stationPayment = ref.read(stationProvider);

    // 🔥 Reemplazos dinámicos
    file = file.replaceAll(
      "[token]",
      stationPayment.createdPayment!.requestReference,
    );
    file = file.replaceAll(
      "[station]",
      stationPayment.selectedChargingStation!.companyName,
    );

    file = file.replaceAll(
      "[currency]",
      stationPayment.createdPayment!.currency,
    );

    file = file.replaceAll(
      "[p_key]",
      stationPayment.selectedPaymentGateway!.settings!['public_key'],
    );

    file = file.replaceAll("[invoice]", stationPayment.createdPayment!.invoice);
    file = file.replaceAll("[amount]", stationPayment.createdPayment!.amount);
    file = file.replaceAll(
      "[name_billing]",
      "${user.userLogin!.info.user.name} ${user.userLogin!.info.user.lastName}",
    );
    file = file.replaceAll(
      "[address_billing]",
      user.userLogin!.info.user.email,
    );
    file = file.replaceAll(
      "[type_doc_billing]",
      user.userLogin!.info.user.documentType.toLowerCase(),
    );
    file = file.replaceAll(
      "[mobilephone_billing]",
      user.userLogin!.info.user.phoneNumber,
    );
    file = file.replaceAll(
      "[number_doc_billing]",
      user.userLogin!.info.user.documentNumber,
    );

    setState(() {
      htmlContent = file;
    });

    debugPrint(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: size.width * 0.08,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Epayco Payment gateway",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: size.width * 0.05,
              ),
            ),
            Text(
              "Epayco",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: size.width * 0.04,
              ),
            ),
          ],
        ),
      ),
      body: htmlContent == null
          ? const Center(child: CircularProgressIndicator())
          : InAppWebView(
              initialData: InAppWebViewInitialData(
                data: htmlContent!,
                baseUrl: WebUri("https://localhost"),
              ),
            ),
    );
  }
}
