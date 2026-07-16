import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/sale.dart';
import 'package:tankio/widget/modal/sale_detail_modal.dart';

class PurchaseHistory extends ConsumerStatefulWidget {
  const PurchaseHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PurchaseHistoryState();
}

class _PurchaseHistoryState extends ConsumerState<PurchaseHistory> {
  String _formatAmount(num value) {
    return NumberFormat.decimalPattern('es_CO').format(value);
  }

  @override
  void initState() {
    loadSales();
    super.initState();
  }

  void loadSales() async {
    await Future.microtask(() async {
      await ref.read(saleProvider).getSaleByUserId();
    });
  }

  (String, Color, IconData) _statusData(
    AppLocalizations l10n,
    dynamic isZeroSale,
  ) {
    if (isZeroSale == true) {
      return (
        l10n.reservationLabel,
        const Color(0xFFB45309),
        Icons.lock_clock_rounded,
      );
    }
    return (l10n.saleLabel, const Color(0xFF166534), Icons.payments_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final sale = ref.watch(saleProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            l10n.purchaseHistoryTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.044,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          leading: const SizedBox(),
        ),
        body: sale.listSale.isEmpty
            ? Center(
                child: Text(
                  l10n.noPurchaseHistoryFound,
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
                  await sale.getSaleByUserId();
                },
                backgroundColor: Colors.black12,
                height: size.height * 0.1,
                color: Colors.white,
                showChildOpacityTransition: true,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: const Color(0xFFF9F9F9),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: sale.activityFilterOptions.map((e) {
                            return TextButton(
                              onPressed: () {
                                sale.activeFilterOption(id: e['id']);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 8,
                                ),
                                decoration: e['active']
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            blurStyle: BlurStyle.normal,
                                            color: Colors.black12,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      )
                                    : BoxDecoration(),
                                child: Text(
                                  e['label'],
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: size.width * 0.036,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Flexible(
                      child: ListView.builder(
                        itemCount: sale.listSaleFilter.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemBuilder: (context, index) {
                          final item = sale.listSaleFilter[index];
                          final status = _statusData(l10n, item.zeroSale);
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) {
                                  return SaleDetailModal(sale: item);
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: CircleAvatar(
                                      backgroundColor: const Color(0xFFF6F6F6),
                                      radius: size.width * 0.07,
                                      child: Icon(
                                        item.systemId == 2
                                            ? Icons.ev_station
                                            : Icons.local_gas_station,
                                        color: Colors.black,
                                        size: size.width * 0.07,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          item.productName,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF535862),
                                            fontSize: size.width * 0.03,
                                          ),
                                        ),
                                        Text(
                                          item.finalDateSale,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            60,
                                          ),
                                          color: status.$2.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                        child: Text(
                                          status.$1,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: size.width * 0.036,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "\$ ${_formatAmount(item.money)}",
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: size.width * 0.041,
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
      ),
    );
  }
}
