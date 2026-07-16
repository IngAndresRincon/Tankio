import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/widget/modal/biometric_permission_modal.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 0),
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.1,
            color: Colors.white,
          ),
          Container(
            width: double.infinity,
            height: size.height * 0.8,
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.loginWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.051,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.loginSubtitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: user.controllerEmailLogin,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: l10n.emailLabel,
                    labelStyle: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade700,

                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: user.controllerPasswordLogin,
                  keyboardType: TextInputType.text,
                  obscureText: !showPassword,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        showPassword = !showPassword;
                        setState(() {});
                      },
                      icon: Icon(
                        !showPassword
                            ? Icons.key_off_rounded
                            : Icons.key_rounded,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_outlined),
                    labelText: l10n.passwordLabel,
                    labelStyle: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade700,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (context.mounted) {
                          Navigator.pushNamed(context, '/recovery-password');
                        }
                      },
                      child: Text(
                        l10n.forgotPassword,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.black87,
                          fontSize: size.width * 0.031,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    // Aquí iría la lógica de autenticación biométrica

                    // AppStatusModal.show(
                    //   context: context,
                    //   type: AppModalType.loading,
                    //   title: 'Login',
                    //   message: 'Wait a moment.',
                    //   dismissible: false,
                    // );

                    await user.userAuthentication().then((bool value) {
                      if (value) {
                        if (context.mounted) {
                          Navigator.pushNamed(context, '/home');
                        }
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
                    l10n.loginButton,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.035,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      height: 1,
                      color: Colors.grey.shade400,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        l10n.orText,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.grey.shade600,
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.4,
                      height: 1,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await user.biometricAuthenticate().then((bool value) async {
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
                    elevation: 0,
                    backgroundColor: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    l10n.biometricContinueButton,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF171228),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: size.height * 0.1,
            color: Colors.white,
            child: Center(
              child: TextButton(
                onPressed: () {
                  if (context.mounted) {
                    Navigator.pushNamed(context, '/create-account');
                  }
                },
                child: RichText(
                  text: TextSpan(
                    text: l10n.noAccountPrompt,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: l10n.signUp,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
