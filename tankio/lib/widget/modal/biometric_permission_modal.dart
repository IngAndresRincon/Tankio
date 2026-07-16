import 'package:flutter/material.dart';
import 'package:tankio/l10n/app_localizations.dart';

class BiometricPermissionModal extends StatelessWidget {
  final String title;
  final String message;
  final String primaryText;
  final VoidCallback? onPrimaryPressed;

  const BiometricPermissionModal({
    super.key,
    required this.title,
    required this.message,
    this.primaryText = 'Entendido',
    this.onPrimaryPressed,
  });

  static Future<void> show({
    required BuildContext context,
    String? title,
    String? message,
    String? primaryText,
    VoidCallback? onPrimaryPressed,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BiometricPermissionModal(
          title: title ?? l10n.biometricPermissionTitle,
          message: message ?? l10n.biometricPermissionMessage,
          primaryText: primaryText ?? l10n.ok,
          onPrimaryPressed: onPrimaryPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size.width * 0.1,
              height: 5,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              width: 78,
              height: 78,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF4D8),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.fingerprint_rounded,
                  color: Color(0xFFFFA000),
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.051,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.039,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    onPrimaryPressed ??
                    () {
                      Navigator.pop(context);
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF60AF47),
                  foregroundColor: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                child: Text(
                  primaryText,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
