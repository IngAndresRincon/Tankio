import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/main.dart';
import 'package:tankio/provider/balance.dart';
import 'package:tankio/provider/home.dart';
import 'package:tankio/provider/notification.dart';
import 'package:tankio/provider/station.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/utils/enum.dart';
import 'package:tankio/widget/modal/balance_group_modal.dart';
import 'package:tankio/widget/modal/recharge_modal.dart';
import 'package:tankio/widget/modal/set_up_biometric_modal.dart';
import 'package:tankio/widget/modal/status_modal.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final BuildContext? ctx = navigatorKey.currentContext;
  @override
  void initState() {
    loadRecentActivity();
    super.initState();
  }

  void loadRecentActivity() async {
    await Future.microtask(() async {
      bool isBiometric = await ref.read(userProvider).readBiometricEnable();
      if (!isBiometric) {
        debugPrint("No hay configuración biométrica");

        showModalBottomSheet(
          elevation: 10,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          showDragHandle: true,
          useSafeArea: true,
          context: ctx!,
          builder: (context) {
            return SetupBiometricModal();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final moneyFormat = NumberFormat.decimalPattern('es_CO');
    final user = ref.watch(userProvider);
    final station = ref.watch(stationProvider);
    final balance = ref.watch(balanceProvider);
    final home = ref.watch(homeProvider);
    final noti = ref.watch(notificationProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              home.indexPage = 4;
              home.controllerPage.jumpToPage(home.indexPage);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: size.width * 0.1,
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.homeWelcomeBack,
                style: TextStyle(
                  fontSize: size.width * 0.028,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito',
                ),
              ),
              Text(
                '${user.userLogin!.info.user.name.toUpperCase()} ${user.userLogin!.info.user.lastName.toUpperCase()}',
                style: TextStyle(
                  fontSize: size.width * 0.041,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () async {
                final balance = ref.read(balanceProvider);
                final hasBalance = await balance.getBalanceGroupByUserId();
                if (!context.mounted) return;
                if (hasBalance) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) {
                      return const BalanceGroupModal();
                    },
                  );
                } else {
                  AppStatusModal.show(
                    context: context,
                    type: AppModalType.alert,
                    title: l10n.stationBalanceAlertTitle,
                    message: l10n.stationBalanceAlertMessage,
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE9EAEB)),
                ),
                child: Icon(
                  Icons.point_of_sale_rounded,
                  size: size.width * 0.06,
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/notifications'),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE9EAEB)),
                ),
                child: noti.hasNewNotification
                    ? Icon(
                        Icons.notifications_active,
                        color: Colors.deepOrange.shade400,
                      )
                    : Icon(
                        Icons.notifications_none_rounded,
                        size: size.width * 0.06,
                      ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.27,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment(0.1, 0),
                  colors: <Color>[Color(0xFFDBF9D1), Color(0x66DBF9D1)],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: LiquidPullToRefresh(
                onRefresh: () async {
                  await balance.updateInformationBalance();
                  await ref.read(userProvider).getRecentActivityByuser();
                },
                backgroundColor: Colors.black12,
                height: size.height * 0.1,
                color: Colors.transparent,
                showChildOpacityTransition: true,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 5),
                    Center(
                      child: Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            l10n.walletBalanceLabel,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.036,
                              color: const Color(0xFF60AF47),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '\$ ${moneyFormat.format(user.userLogin?.info.balance?.balance ?? 0)}',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      l10n.availableFundsLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.031,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${l10n.groupLabel} ${user.userLogin?.info.balance?.companyName ?? ''}',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.031,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.lastTopUpLabel,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.031,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${user.userLogin?.info.balance?.lastMoveDate}',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.031,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () async {
                              station.clearFields();
                              await station
                                  .getPaymentGateWaysFromStation()
                                  .then((value) {
                                    if (!context.mounted) return;
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) {
                                        return RechargeModal();
                                      },
                                    );
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF60AF47),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              l10n.rechargeButton,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.035,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: size.width * 0.3,

                          child: ElevatedButton(
                            onPressed: () {
                              // Aquí iría la lógica de autenticación biométrica
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  '/balance-movements',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              l10n.viewWalletButton,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.035,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.15,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(87, 95, 175, 71),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, '/activity');
                            },
                            icon: Icon(
                              Icons.history_rounded,
                              color: Colors.black,
                              size: size.width * 0.08,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        l10n.activityLabel,
                        style: TextStyle(
                          fontSize: size.width * 0.031,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(87, 95, 175, 71),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/vehicles');
                            },
                            icon: Icon(
                              Icons.directions_car_outlined,
                              color: Colors.black,
                              size: size.width * 0.08,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        l10n.vehiclesLabel,
                        style: TextStyle(
                          fontSize: size.width * 0.031,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  //     Container(
                  //       width: size.width * 0.15,
                  //       height: size.width * 0.15,
                  //       decoration: BoxDecoration(
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Color.fromARGB(87, 95, 175, 71),
                  //             blurRadius: 10,
                  //             offset: Offset(0, 0),
                  //           ),
                  //         ],
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(80),
                  //       ),
                  //       child: Center(
                  //         child: IconButton(
                  //           onPressed: () {
                  //             //Navigator.pushNamed(context, '/inselect-schedule');
                  //           },
                  //           icon: Icon(
                  //             Icons.book_outlined,
                  //             color: Colors.black,
                  //             size: size.width * 0.08,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Text(
                  //       l10n.bookingLabel,
                  //       style: TextStyle(
                  //         fontSize: size.width * 0.031,
                  //         fontFamily: 'Nunito',
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(87, 95, 175, 71),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              home.indexPage = 3;
                              home.controllerPage.jumpToPage(home.indexPage);
                            },
                            icon: Icon(
                              Icons.receipt_long_rounded,
                              color: Colors.black,
                              size: size.width * 0.08,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        l10n.homeNavPurchase,
                        style: TextStyle(
                          fontSize: size.width * 0.031,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                l10n.recentActivityLabel,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: size.width * 0.041,
                ),
              ),
            ),
            Container(
              height: size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE9EAEB), width: 1),
              ),
              child: user.programminglist.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noRecentActivityMessage,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: user.programminglist.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 10,
                      ),
                      itemBuilder: (context, index) {
                        final item = user.programminglist[index];
                        return InkWell(
                          onTap: () {
                            if (item.programmingStatusId == 3) {
                              Navigator.of(
                                context,
                              ).pushNamed('/activity-electric-charger');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFF6F6F6),
                                  radius: size.width * 0.07,
                                  child: Icon(
                                    item.systemId == 1
                                        ? Icons.local_gas_station
                                        : Icons.ev_station,
                                    color: Colors.black,
                                    size: size.width * 0.07,
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        item.stationName,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: size.width * 0.036,
                                        ),
                                      ),

                                      Text(
                                        item.registrationDate,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF535862),
                                          fontSize: size.width * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "\$ ${moneyFormat.format(item.programmingMoney)}",
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        fontSize: size.width * 0.046,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                      ),
                                      child: Text(
                                        item.status.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w800,
                                          color: item.programmingStatusId == 3
                                              ? Colors.green.shade200
                                              : item.programmingStatusId == 2
                                              ? Colors.blue.shade200
                                              : item.programmingStatusId == 6
                                              ? Colors.orange.shade200
                                              : const Color(0xFF535862),
                                          fontSize: size.width * 0.031,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
