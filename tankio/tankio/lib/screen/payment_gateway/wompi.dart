import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/provider/station.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WompiCheckoutPage extends ConsumerStatefulWidget {
  const WompiCheckoutPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WompiCheckoutPageState();
}

class _WompiCheckoutPageState extends ConsumerState<WompiCheckoutPage> {
  WebViewController? controller;

  String checkoutUrl =
      'https://checkout.wompi.co/p/?'
      'public-key=[public_key]'
      '&currency=[currency]'
      '&amount-in-cents=[amount]'
      '&reference=[reference]'
      '&signature:integrity=[signature]'
      '&redirect-url=https://subdivinely-unreciprocal-hee.ngrok-free.dev/api/sandbox.tankio/v1/payment-gateway/webhook/wompi/validation/response';

  @override
  void initState() {
    super.initState();
    loadPaymentGatewayData();
  }

  void loadPaymentGatewayData() async {
    final stationPayment = ref.read(stationProvider);
    int amountPayment = int.parse(stationPayment.createdPayment!.amount) * 100;

    checkoutUrl = checkoutUrl.replaceAll(
      "[public_key]",
      stationPayment.selectedPaymentGateway!.settings!['public_key'],
    );

    checkoutUrl = checkoutUrl.replaceAll(
      "[currency]",
      stationPayment.createdPayment!.currency,
    );
    checkoutUrl = checkoutUrl.replaceAll("[amount]", amountPayment.toString());
    checkoutUrl = checkoutUrl.replaceAll(
      "[reference]",
      stationPayment.createdPayment!.requestReference,
    );
    checkoutUrl = checkoutUrl.replaceAll(
      "[signature]",
      stationPayment.createdPayment!.metadata['signature'],
    );

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('/payment-result')) {
              final uri = Uri.parse(url);
              final transactionId = uri.queryParameters['id'];

              Navigator.pop(context, transactionId);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: size.width * 0.08,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Wompi Payment gateway",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: size.width * 0.05,
              ),
            ),
          ],
        ),
      ),
      body: controller == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller!),
    );
  }
}
