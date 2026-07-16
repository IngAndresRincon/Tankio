import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';

class DeleteAccount extends ConsumerWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
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
          l10n.deleteAccountTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        children: [
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4F4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: const Color(0xFFB42318),
                    size: size.width * 0.09,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.requestDeletionTitle,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7A271A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.requestDeletionMessage,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFB42318),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.whatWillBeLostTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: size.width * 0.041,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFD5D7DA)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_off_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Text(
                    l10n.profileInformationTitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: size.width * 0.036,
                    ),
                  ),
                  subtitle: Text(
                    l10n.profileInformationSubtitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                      fontSize: size.width * 0.031,
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade200, indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(
                    Icons.directions_car_filled_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Text(
                    l10n.savedVehiclesTitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: size.width * 0.036,
                    ),
                  ),
                  subtitle: Text(
                    l10n.savedVehiclesSubtitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                      fontSize: size.width * 0.031,
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade200, indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Text(
                    l10n.historyRecordsTitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: size.width * 0.036,
                    ),
                  ),
                  subtitle: Text(
                    l10n.historyRecordsSubtitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                      fontSize: size.width * 0.031,
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade200, indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(
                    Icons.qr_code_2_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Text(
                    l10n.qrAccessTitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: size.width * 0.036,
                    ),
                  ),
                  subtitle: Text(
                    l10n.qrAccessSubtitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                      fontSize: size.width * 0.031,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.refundRequestTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: size.width * 0.041,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD5D7DA)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF8FF),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.wallet_outlined,
                    color: const Color(0xFF175CD3),
                    size: size.width * 0.08,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ifYouStillHaveBalanceTitle,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.refundRequestMessage,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFD5D7DA)),
                        ),
                        child: Text(
                          "refunds@tankio-demo.com",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF175CD3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.refundRequestInstructions,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.031,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD5D7DA)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.grey.shade700,
                  size: size.width * 0.08,
                ),
                const SizedBox(width: 12),
                Expanded(
                child: Text(
                    l10n.deleteAccountNotice,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.032,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              _showDeleteAccountConfirmation(context, user, l10n);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD92D20),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: Text(
              l10n.deleteAccountButton,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

void _showDeleteAccountConfirmation(
  BuildContext pageContext,
  UserProvider user,
  AppLocalizations l10n,
) {
  showModalBottomSheet(
    context: pageContext,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (modalContext) {
      final size = MediaQuery.of(modalContext).size;
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
                  color: Color(0xFFFFEAEA),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.warning_rounded,
                    color: Color(0xFFE53935),
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.deleteAccountConfirmTitle,
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
                l10n.deleteAccountConfirmMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.039,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(modalContext);
                    final bool deleted = await user.deleteAccount();
                    if (!pageContext.mounted) return;
                    if (!deleted) return;

                    await user.clearSessionAndLogout(preserveBiometric: false);
                    if (!pageContext.mounted) return;

                    Navigator.of(pageContext).pushNamedAndRemoveUntil(
                      '/login-biometric',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child: Text(
                    l10n.deleteAccountConfirmButton,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(modalContext),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
