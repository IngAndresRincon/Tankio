import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';

class RecoveryPasswordScreen extends ConsumerWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    return Scaffold(
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
        children: [
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
                    l10n.recoverPasswordTitle,
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
                    l10n.recoverPasswordSubtitle,
                    textAlign: TextAlign.center,
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

                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: l10n.recoverPasswordEmailLabel,
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
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    await user.passwordRecovery().then((value) {
                      if (!context.mounted) return;
                      if (value) {
                        Navigator.pop(context);
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
                    l10n.sendRecoveryEmailButton,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.035,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                  Navigator.of(context).pop(); //Regresa al login
                },
                child: RichText(
                  text: TextSpan(
                    text: l10n.rememberPasswordPrompt,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: l10n.signIn,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF60AF47),
                        ),
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
