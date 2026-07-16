import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';

class SecuritySettings extends ConsumerStatefulWidget {
  const SecuritySettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecuritySettingsState();
}

class _SecuritySettingsState extends ConsumerState<SecuritySettings> {
  bool isEnable = false;

  @override
  void initState() {
    loadBiometriSettings();
    super.initState();
  }

  void loadBiometriSettings() async {
    await Future.microtask(() async {
      await ref.read(userProvider).readBiometricEnable().then((value) {
        setState(() {
          isEnable = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.read(userProvider);

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
          l10n.securitySettingsTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: size.height * 0.35,
            padding: EdgeInsets.all(35),
            child: Image.asset(
              'assets/security_settings_biometric.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Text(
              l10n.biometricAuthenticationHeader,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontSize: size.width * 0.041,
              ),
            ),
          ),
          Center(
            child: Text(
              l10n.biometricProtectionSubtitle,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                color: const Color(0xFF535862),
                fontSize: size.width * 0.036,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFD5D7DA)),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    setState(() {
                      isEnable = !isEnable;
                    });
                    await user.saveBiometricSettings(enable: isEnable);
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: const Color(0xFFF6F6F6),
                        ),
                        child: Icon(
                          Icons.fingerprint_sharp,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.enableBiometricLoginTitle,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                fontSize: size.width * 0.036,
                              ),
                            ),
                            Text(
                              l10n.enableBiometricLoginSubtitle,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                                fontSize: size.width * 0.031,
                              ),
                            ),
                          ],
                        ),
                      ),
                      !isEnable
                          ? Icon(
                              Icons.circle_outlined,
                              color: Colors.black,
                              size: 40,
                            )
                          : Icon(
                              Icons.check_circle_outline_outlined,
                              color: const Color(0xFF60AF47),
                              size: 40,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color(0xFFF6F6F6),
                      ),
                      child: Icon(
                        Icons.center_focus_weak_outlined,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.faceIdTitle,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            fontSize: size.width * 0.036,
                          ),
                        ),
                        Text(
                          l10n.faceIdSubtitle,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            fontSize: size.width * 0.031,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: const Color(0xFFF6F6F6),
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                Flexible(
                  child: Text(
                    l10n.biometricDataSecureMessage,
                    style: TextStyle(
                      color: const Color(0xFF181D27),
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.036,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.aboutBiometricLoginTitle,
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFD5D7DA)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color(0xFFF6F6F6),
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.fasterAccessTitle,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: size.width * 0.036,
                            ),
                          ),
                          Text(
                            l10n.fasterAccessSubtitle,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              fontSize: size.width * 0.031,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color(0xFFF6F6F6),
                      ),
                      child: Icon(
                        Icons.safety_check_sharp,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.secureAndPrivateTitle,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: size.width * 0.036,
                            ),
                          ),
                          Text(
                            l10n.secureAndPrivateSubtitle,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              fontSize: size.width * 0.031,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color(0xFFF6F6F6),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.youAreInControlTitle,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: size.width * 0.036,
                            ),
                          ),
                          Text(
                            l10n.youAreInControlSubtitle,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              fontSize: size.width * 0.031,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.otherOptionsTitle,
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFD5D7DA)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color(0xFFF6F6F6),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.usePasswordInsteadTitle,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: size.width * 0.036,
                            ),
                          ),
                          Text(
                            l10n.usePasswordInsteadSubtitle,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              fontSize: size.width * 0.031,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color(0xFFF6F6F6),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.manageBiometricPermissionsTitle,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: size.width * 0.036,
                            ),
                          ),
                          Text(
                            l10n.manageBiometricPermissionsSubtitle,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              fontSize: size.width * 0.031,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
