import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewInvoice extends ConsumerStatefulWidget {
  final String url;

  const ViewInvoice({super.key, required this.url});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends ConsumerState<ViewInvoice> {
  WebViewController? controller;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    final cleanedUrl = widget.url.trim();
    if (cleanedUrl.isEmpty) {
      errorMessage = 'empty';
      return;
    }

    final normalizedUrl = cleanedUrl.startsWith('http')
        ? cleanedUrl
        : 'https://$cleanedUrl';

    final parsedUrl = Uri.tryParse(normalizedUrl);
    if (parsedUrl == null || parsedUrl.host.isEmpty) {
      errorMessage = 'invalid';
      return;
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint(error.description);
          },
        ),
      )
      ..loadRequest(parsedUrl);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: size.width * 0.06,
          ),
        ),
        title: Text(
          l10n.viewInvoiceTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.viewInvoiceErrorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            )
          : controller == null
              ? Center(
                  child: Text(
                    l10n.viewInvoiceLoadingMessage,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )
              : WebViewWidget(controller: controller!),
    );
  }
}
