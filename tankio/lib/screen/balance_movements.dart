import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/balance.dart';
import 'package:tankio/utils/money_utils.dart';

class BalanceMovements extends ConsumerStatefulWidget {
  const BalanceMovements({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BalanceMovementsState();
}

class _BalanceMovementsState extends ConsumerState<BalanceMovements> {
  @override
  void initState() {
    loadBalanceMovements();
    super.initState();
  }

  void loadBalanceMovements() async {
    await Future.microtask(() async {
      await ref.read(balanceProvider).getBalanceMovementsByUserId();
    });
  }

  String _movementLabel(AppLocalizations l10n, String movement) {
    switch (movement.toLowerCase()) {
      case 'purchase':
        return l10n.purchaseLabel;
      case 'sale':
        return l10n.saleLabel;
      case 'discount':
        return l10n.discountLabel;
      case 'return':
        return l10n.returnLabel;
      case 'refund':
        return l10n.refundLabel;
      case 'reservation':
        return l10n.reservationLabel;
      default:
        return movement.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final balance = ref.watch(balanceProvider);
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
          l10n.balanceMovementsTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: balance.listMovements.isEmpty
          ? Center(
              child: Text(
                l10n.balanceMovementEmpty,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : LiquidPullToRefresh(
              onRefresh: () async {
                await ref.read(balanceProvider).getBalanceMovementsByUserId();
              },
              backgroundColor: Colors.black12,
              height: size.height * 0.1,
              color: Colors.white,
              showChildOpacityTransition: true,
              child: ListView.builder(
                itemCount: balance.listMovements.length,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) {
                  final item = balance.listMovements[index];
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: const Color(0xFFE9EAEB),
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          item.balanceMovementTypeId == 1
                              ? Icons.payments_sharp
                              : item.balanceMovementTypeId == 2
                              ? Icons.remove_circle_outline_rounded
                              : item.balanceMovementTypeId == 3
                              ? Icons.lock_clock_rounded
                              : item.balanceMovementTypeId == 4
                              ? Icons.add_circle_outline_rounded
                              : item.balanceMovementTypeId == 5
                              ? Icons.receipt_long_rounded
                              : Icons.undo_rounded,
                          color: item.balanceMovementTypeId == 1
                              ? Colors.green.shade400
                              : item.balanceMovementTypeId == 2
                              ? Colors.red.shade400
                              : item.balanceMovementTypeId == 3
                              ? Colors.red.shade400
                              : item.balanceMovementTypeId == 4
                              ? Colors.green.shade400
                              : item.balanceMovementTypeId == 5
                              ? Colors.orange.shade400
                              : Colors.blue.shade400,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _movementLabel(l10n, item.movement),
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.036,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            item.stationName.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.028,
                              color: const Color(0xFF535862),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              item.balanceMovementTypeId == 1 ||
                                      item.balanceMovementTypeId == 4
                                  ? Icon(
                                      Icons.add,
                                      color: Colors.green.shade400,
                                      fontWeight: FontWeight.w800,
                                      size: size.width * 0.04,
                                    )
                                  : Icon(
                                      Icons.remove,
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.w800,
                                      size: size.width * 0.04,
                                    ),
                              Text(
                                " \$ ${formatMoney(item.amount)}",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: size.width * 0.051,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item.registrationDate,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.026,
                              color: const Color(0xFF535862),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
