import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/socketio.dart';
import 'package:tankio/provider/user.dart';

class SessionExpiredModal extends ConsumerStatefulWidget {
  const SessionExpiredModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditVehicleModelState();
}

class _EditVehicleModelState extends ConsumerState<SessionExpiredModal> {
  bool isActive = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.4,
        builder: (context, scrollController) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),

                    children: [
                      SizedBox(height: 5),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/session_expired.png",
                          width: 60,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        l10n.sessionExpiredTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.046,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        l10n.sessionExpiredMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.036,
                          color: const Color(0xFF535862),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      OutlinedButton(
                        onPressed: () async {
                          ref
                              .read(socketControllerProvider)
                              .markSessionExpiredHandled();
                          await ref.read(userProvider).clearSessionAndLogout();
                          if (!context.mounted) return;
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamedAndRemoveUntil(
                            '/login_biometric',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          l10n.logoutButton,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.036,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
