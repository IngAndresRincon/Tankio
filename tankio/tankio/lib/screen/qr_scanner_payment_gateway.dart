import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/utils/encrypter.dart';

class QRScannerPaymentGateway extends StatefulWidget {
  const QRScannerPaymentGateway({super.key});

  @override
  State<QRScannerPaymentGateway> createState() =>
      _QRScannerPaymentGatewayState();
}

class _QRScannerPaymentGatewayState extends State<QRScannerPaymentGateway> {
  String qrResult = "Scan a QR code";
  final encriptador encry = encriptador();
  bool scanned = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _qrReading(BarcodeCapture capture) async {
    if (scanned) return;
    try {
      scanned = true;
      final qr = capture.barcodes.first.displayValue;

      if (qr.toString().length > 4) {
        final codePositionText = encry
            .desencrypter(qr.toString())
            .replaceAll(r'\"', '"');
        Navigator.pop(context, codePositionText);

        // if (codePositionText != "" && codePositionText.startsWith("TKO")) {
        //   Navigator.pop(context, false);
        // }

        // if (codePositionText != "" && codePositionText.startsWith("INS")) {
        //   Navigator.pop(context, true);
        // }
      } else {
        debugPrint("Longitud no valida");
      }
    } catch (error) {
      // LoggerService.error(error);
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      scanned = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: size.width * 0.06,
          ),
        ),
        title: Text(
          l10n.scanQrCodeTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade900, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: MobileScanner(
                      controller: controller,
                      onDetect: _qrReading,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Text(
                        l10n.scanQrCodeLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        l10n.scanQrCodeSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.black54),
                    onPressed: () {
                      controller.toggleTorch();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch, color: Colors.black54),
                    onPressed: () {
                      controller.switchCamera();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
