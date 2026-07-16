import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';

class TermsConditions extends ConsumerStatefulWidget {
  const TermsConditions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsConditionsState();
}

class _TermsConditionsState extends ConsumerState<TermsConditions> {
  bool userAgree = false;

  @override
  void initState() {
    loadStatusTermsAndConditions();
    super.initState();
  }

  void loadStatusTermsAndConditions() async {
    await Future.microtask(() async {
      await ref.read(userProvider).getStatusTYC().then((bool value) {
        setState(() {
          userAgree = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: size.width * 0.06,
          ),
        ),
        title: Text(
          l10n.termsConditionsTitleScreen,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 0.4],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF60AF47), Color(0xFFFFFFFF)],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    l10n.legalTermsTitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.051,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsLastUpdated,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.termsSection1Title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection1Body,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection2Title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection2Body,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection3Title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection3Body,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection4Title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection4Body,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection5Title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection5Body,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection6Title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.termsSection6Body,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerStart,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    userAgree = !userAgree;
                  });
                },
                label: Text(
                  l10n.termsAgreementText,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.034,
                    color: Colors.black,
                  ),
                ),
                icon: Icon(
                  !userAgree
                      ? Icons.check_box_outline_blank_rounded
                      : Icons.check_box_outlined,
                  size: size.width * 0.09,
                  color: !userAgree
                      ? const Color(0xFF535862)
                      : const Color(0xFF60AF47),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                user.registerTYC(isAgree: userAgree).then((value) {
                  if (!context.mounted) return;
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
                l10n.acceptAndContinueButton,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.035,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
