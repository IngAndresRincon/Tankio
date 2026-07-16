import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/page/index_main.dart';
import 'package:tankio/page/map.dart';
import 'package:tankio/page/profile.dart';
import 'package:tankio/page/purchase_history.dart';
import 'package:tankio/provider/map.dart';
import 'package:tankio/provider/sale.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/utils/enum.dart';
import 'package:tankio/widget/modal/status_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final controllerPage = PageController(initialPage: 0);
  int indexPage = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final currentUser = user.userLogin;

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      });
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: PageView(
        controller: controllerPage,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (value) {},

        children: [
          MainPage(),
          MapPage(),
          Container(child: Text(l10n.notImplemented)),
          PurchaseHistory(),
          ProfilePage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: size.width * 0.16,
        height: size.width * 0.16,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF60AF47),

          elevation: 10,
          isExtended: true,
          onPressed: () {
            if (currentUser.info.balance == null ||
                currentUser.info.balance!.balance < 1000) {
              AppStatusModal.show(
                context: context,
                type: AppModalType.alert,
                title: l10n.informationTitle,
                message:
                    l10n.insufficientBalanceMessage,
              );
            } else {
              Navigator.pushNamed(context, '/qr-scanner');
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(80),
          ),
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: size.width * 0.08,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,

        child: Container(
          height: size.height * 0.09,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: const Color(0xFFE9EAEB), width: 1),
            ),
          ),

          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey.shade500,
            currentIndex: indexPage,
            onTap: (value) async {
              setState(() {
                indexPage = value == 2 ? value + 1 : value;
              });
              if (indexPage == 1) {
                await ref.read(mapProvider).solicitarPermisos();
                await ref.read(mapProvider).getAvailableStationLocations();
              }

              if (indexPage == 3) {
                await ref.read(saleProvider).getSaleByUserId();
              }
              controllerPage.jumpToPage(indexPage);
            },
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w300,
              color: Colors.grey.shade600,
              fontSize: size.width * 0.031,
            ),
            selectedLabelStyle: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: size.width * 0.031,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: l10n.homeNavHome,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fmd_good_outlined),
                label: l10n.homeNavMap,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.abc_outlined, color: Colors.transparent),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded),
                label: l10n.homeNavPurchase,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: l10n.homeNavProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
