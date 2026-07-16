import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tankio/utils/enum.dart';

class AppStatusModal extends StatelessWidget {
  final AppModalType type;
  final String title;
  final String message;
  final String? primaryText;
  final VoidCallback? onPrimaryPressed;
  final bool dismissible;

  const AppStatusModal({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.primaryText,
    this.onPrimaryPressed,
    this.dismissible = true,
  });

  static Future<void> show({
    required BuildContext context,
    required AppModalType type,
    required String title,
    required String message,
    String? primaryText,
    VoidCallback? onPrimaryPressed,
    bool dismissible = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: dismissible,
      enableDrag: dismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AppStatusModal(
          type: type,
          title: title,
          message: message,
          primaryText: primaryText,
          onPrimaryPressed: onPrimaryPressed,
          dismissible: dismissible,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
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
            if (dismissible)
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
              width: double.infinity,
              height: 78,
              decoration: BoxDecoration(
                color: config.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: type == AppModalType.loading
                    ? SizedBox(
                        width: 34,
                        height: 34,
                        child: Center(
                          child: LoadingAnimationWidget.hexagonDots(
                            color: const Color(0xFF60AF47),
                            size: 60,
                          ),
                        ),
                      )
                    : Icon(
                        config.icon,
                        color: config.color,
                        size: size.width * 0.15,
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
                color: Color(0xFF1E1E1E),
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

            if (primaryText != null) ...[
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
                    backgroundColor: config.color,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child: Text(
                    primaryText!,
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
          ],
        ),
      ),
    );
  }

  _ModalConfig _getConfig() {
    switch (type) {
      case AppModalType.loading:
        return _ModalConfig(
          color: const Color(0xFF1D6BFF),
          backgroundColor: const Color(0xFFF6F6F6),
          icon: Icons.hourglass_empty,
        );

      case AppModalType.alert:
        return _ModalConfig(
          color: const Color(0xFFFFA000),
          backgroundColor: const Color(0xFFFFF4D8),
          icon: Icons.warning_rounded,
        );

      case AppModalType.success:
        return _ModalConfig(
          color: const Color(0xFF20B26B),
          backgroundColor: const Color(0xFFE7F8F0),
          icon: Icons.check_rounded,
        );

      case AppModalType.error:
        return _ModalConfig(
          color: const Color(0xFFE53935),
          backgroundColor: const Color(0xFFFFEAEA),
          icon: Icons.close_rounded,
        );
    }
  }
}

class _ModalConfig {
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  _ModalConfig({
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });
}
