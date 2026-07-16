import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/locale.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/widget/modal/biometric_permission_modal.dart';

class LoginBiometricScreen extends ConsumerStatefulWidget {
  const LoginBiometricScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      LoginBiometricScreenState();
}

class LoginBiometricScreenState extends ConsumerState<LoginBiometricScreen> {
  String get selectedLanguageLabel {
    final locale = ref.read(localeProvider).valueOrNull ?? const Locale('en');
    switch (locale.languageCode) {
      case 'en':
        return 'EN';
      default:
        return 'ES';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final appLocale =
        ref.watch(localeProvider).valueOrNull ?? const Locale('en');

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          //title: Image.asset("assets/insepet_background_1.png", width: 65),
          leading: Image.asset(
            "assets/insepet_background_1.png",
            width: 80,
            height: 70,
            fit: BoxFit.fitWidth,
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              tooltip: l10n.selectLanguageTooltip,
              onSelected: (value) {
                ref
                    .read(localeProvider.notifier)
                    .setLocale(Locale(value == '2' ? 'en' : 'es'));
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: '1',
                  child: Text(
                    '${l10n.languageSpanish} - ES',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text(
                    '${l10n.languageEnglish} - EN',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              initialValue: appLocale.languageCode == 'en' ? '2' : '1',
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF60AF47)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language_rounded,
                      color: Color(0xFF60AF47),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      selectedLanguageLabel,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        color: Color(0xFF60AF47),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Color(0xFF60AF47),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              height: size.height * (size.height < 670 ? 0.45 : 0.5),
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Image.asset(
                  'assets/biometric-login.png',
                  width: size.width * 0.8,
                  fit: BoxFit.fill,
                  scale: 1.5,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: size.height * (size.height < 670 ? 0.45 : 0.4),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(180, 95, 175, 71),
                    blurRadius: 60,
                    offset: Offset(0, -5),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 0,
                ),
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/logo-tankio.png', width: 50),
                        Text(
                          'Tankio!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.072,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    l10n.biometricWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.061,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.biometricWelcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await user.biometricAuthenticate().then((
                        bool value,
                      ) async {
                        if (!context.mounted) return;
                        if (value) {
                          await user.biometricLogin().then((value) {
                            if (!context.mounted) return;
                            if (value) {
                              Navigator.pushNamed(context, '/home');
                            }
                          });
                        } else {
                          BiometricPermissionModal.show(context: context);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF60AF47),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      l10n.biometricUnlockButton,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (mounted) {
                        Navigator.pushNamed(context, '/login');
                      }
                    },
                    child: Text(
                      l10n.biometricLoginWithEmail,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
