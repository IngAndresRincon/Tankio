import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/widget/modal/logout_confirmation_modal.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final currentUser = user.userLogin;

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      });
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            l10n.profileTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.044,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          leading: const SizedBox(),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFFAFAFA),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(Icons.person, size: size.width * 0.12),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${currentUser.info.user.name.toUpperCase()} ${currentUser.info.user.lastName.toUpperCase()}",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: size.width * 0.041,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          currentUser.info.user.email,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: size.width * 0.033,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton(
                          onPressed: () {
                            LogoutConfirmationModal.show(
                              context: context,
                              onConfirm: () async {
                                await ref
                                    .read(userProvider)
                                    .clearSessionAndLogout();
                                if (!context.mounted) return;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login_biometric',
                                  (route) => false,
                                );
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            l10n.logout,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.041,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.accountInfoTitle,
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
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD5D7DA)),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/personal-information');
                    },
                    leading: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      l10n.personalInfoTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                    subtitle: Text(
                      l10n.personalInfoSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        fontSize: size.width * 0.031,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: size.width * 0.1,
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/vehicles');
                    },
                    leading: Icon(
                      Icons.directions_car_filled_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      l10n.vehiclesTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                    subtitle: Text(
                      l10n.vehiclesSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        fontSize: size.width * 0.031,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: size.width * 0.1,
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    indent: 20,
                    endIndent: 20,
                  ),

                  // ListTile(
                  //             onTap: () {
                  //               showCupertinoModalPopup(
                  //                 context: context,
                  //                 builder: (context) {
                  //                   return Center(
                  //                     child: Consumer(
                  //                       builder: (context, ref, child) {
                  //                         return Container(
                  //                           padding: EdgeInsets.all(20),
                  //                           width: size.width * 0.8,
                  //                           height: size.width * 0.8,
                  //                           decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius: BorderRadius.circular(10),
                  //                           ),
                  //                           child: Center(
                  //                             child: QrImageView(
                  //                               data: currentUser.token,
                  //                               version: QrVersions.auto,
                  //                               size: size.width * 0.7,
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                     ),
                  //                   );
                  //                 },
                  //               );
                  //             },
                  //             leading: Icon(
                  //               Icons.qr_code_2_rounded,
                  //               color: Colors.black,
                  //               size: 40,
                  //             ),
                  //             title: Text(
                  //               l10n.myQrCodeTitle,
                  //               style: TextStyle(
                  //                 fontFamily: 'Nunito',
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Colors.black,
                  //                 fontSize: size.width * 0.036,
                  //               ),
                  //             ),
                  //             subtitle: Text(
                  //               l10n.yourQrIdentifier,
                  //               style: TextStyle(
                  //                 fontFamily: 'Nunito',
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Color(0xFF6B7280),
                  //                 fontSize: size.width * 0.031,
                  //               ),
                  //             ),
                  //             trailing: Icon(
                  //               Icons.chevron_right_rounded,
                  //               size: size.width * 0.1,
                  //               color: Colors.black,
                  //             ),
                  //           ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.securityTitle,
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
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD5D7DA)),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/change-password');
                    },
                    leading: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      l10n.changePasswordTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                    subtitle: Text(
                      l10n.changePasswordSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        fontSize: size.width * 0.031,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: size.width * 0.1,
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/security-settings');
                    },
                    leading: Icon(
                      Icons.shield_outlined,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      l10n.biometricAuthenticationTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                    subtitle: Text(
                      l10n.biometricAuthenticationSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        fontSize: size.width * 0.031,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: size.width * 0.1,
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/delete-account');
                    },
                    leading: Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      l10n.deleteAccountTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                    subtitle: Text(
                      l10n.deleteAccountSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        fontSize: size.width * 0.031,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: size.width * 0.1,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.preferencesTitle,
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
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD5D7DA)),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                    leading: Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      l10n.notificationsTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                    subtitle: Text(
                      l10n.notificationsSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        fontSize: size.width * 0.031,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: size.width * 0.1,
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/terms_&_conditions');
                    },
                    leading: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      l10n.termsConditionsTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: size.width * 0.036,
                      ),
                    ),
                    subtitle: Text(
                      l10n.termsConditionsSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        fontSize: size.width * 0.031,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: size.width * 0.1,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
