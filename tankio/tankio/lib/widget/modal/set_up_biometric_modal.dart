import 'package:flutter/material.dart';
import 'package:tankio/l10n/app_localizations.dart';

class SetupBiometricModal extends StatelessWidget {
  const SetupBiometricModal({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.35,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: ListView(
        children: [
          SizedBox(height: 10),
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 50,
            child: Center(
              child: Icon(
                Icons.fingerprint_sharp,
                color: Colors.green.shade200,
                size: size.width * 0.2,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            l10n.setupBiometricReminderMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.036,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E1E),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Navigator.popAndPushNamed(context, '/security-settings');
            },
            style: ElevatedButton.styleFrom(
              elevation: 1,
              backgroundColor: const Color(0xFF60AF47),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              l10n.setupBiometricConfigureButton,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.036,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              l10n.setupBiometricCloseButton,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.036,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
