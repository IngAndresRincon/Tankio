import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:tankio/payment_gateway/wompi/wompi_checkout.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/station.dart';
import 'package:tankio/provider/user.dart';

class RechargeModal extends ConsumerWidget {
  const RechargeModal({super.key});

  Future<void> paymentRecordResponse(
    StationProvider station,
    BuildContext context,
  ) async {
    await station.createPaymentGateway().then((value) {
      if (!context.mounted) return;
      Navigator.pop(context);
      if (value) {
        if (station.createdPayment!.paymentGatewayId == 1) {
          Navigator.pushNamed(context, '/epayco');
        }
        if (station.createdPayment!.paymentGatewayId == 2) {
          Navigator.pushNamed(context, '/wompi');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final moneyFormat = NumberFormat.decimalPattern('es_CO');
    final station = ref.watch(stationProvider);
    final user = ref.watch(userProvider);
    final amountValue =
        int.tryParse(station.controllerAmountRecharge.text) ?? 0;
    final transactionFee = station.selectedPaymentGateway?.transactionFee ?? 0;
    final totalToPay = amountValue + transactionFee;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),

              // Barra de arrastre
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
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  children: [
                    Text(
                      l10n.currentBalanceLabel,
                      style: TextStyle(
                        color: const Color(0xFF60AF47),
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
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
                      '${l10n.availableFundsLabel} ',
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
                    SizedBox(height: 20),
                    // Text(
                    //   l10n.selectStationLabel,
                    //   style: TextStyle(
                    //     fontFamily: 'Nunito',
                    //     fontSize: size.width * 0.031,
                    //     fontWeight: FontWeight.w800,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
                    // SizedBox(height: 5),

                    // DropdownButtonFormField<String>(
                    //   key: const ValueKey('station-dropdown'),
                    //   initialValue: station.initialValueStationPoint.isEmpty
                    //       ? null
                    //       : station.initialValueStationPoint,
                    //   isExpanded: true,
                    //   autofocus: true,
                    //   autovalidateMode: AutovalidateMode.always,
                    //   barrierDismissible: false,
                    //   style: TextStyle(
                    //     fontFamily: 'Nunito',
                    //     color: Colors.grey.shade800,
                    //     fontSize: size.width * 0.04,
                    //     fontWeight: FontWeight.w600,
                    //   ),

                    //   decoration: InputDecoration(
                    //     prefixIcon: Icon(Icons.store),
                    //     //labelText: l10n.selectStationLabel,
                    //     labelStyle: TextStyle(
                    //       fontFamily: 'Nunito',
                    //       color: Colors.grey.shade700,
                    //       fontSize: size.width * 0.04,
                    //       fontWeight: FontWeight.w300,
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    //   items: station.listStationPoints,
                    //   onChanged: (value) async {
                    //     await station.onChangeStation(
                    //       idstation: int.parse(value ?? "0"),
                    //     );
                    //   },
                    // ),
                    TextButton.icon(
                      onPressed: station.qrScannerPositionCode,
                      label: Text(
                        l10n.scanStationQrHelpLabel,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.034,
                          fontWeight: FontWeight.w600,
                          color: Colors.lightGreen.shade900,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.grey.shade600,
                        size: size.width * 0.04,
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      l10n.selectPaymentGatewayLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      key: const ValueKey('payment-gateway-dropdown'),
                      initialValue: station.initialValuePaymentGateway.isEmpty
                          ? null
                          : station.initialValuePaymentGateway,
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.grey.shade800,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.payments_rounded),
                        //labelText: l10n.selectPaymentGatewayLabel,
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
                      items: station.listPaymentGatewayStation,
                      onChanged: (value) async {
                        station.onChangePaymentGatway(
                          idpayment: int.parse(value ?? "0"),
                        );
                      },
                    ),
                    SizedBox(height: 10),

                    Text(
                      l10n.enterAmountLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.031,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: station.controllerAmountRecharge,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.grey.shade800,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (value) =>
                          station.validateValueField(value: value),
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.lock_outlined),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFEAECF0),
                          ),
                        ),
                        labelText: l10n.amountLabel,
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

                    SizedBox(height: 10),

                    // Wrap(
                    //   alignment: WrapAlignment.spaceEvenly,
                    //   runAlignment: WrapAlignment.spaceEvenly,
                    //   spacing: 18,
                    //   runSpacing: 8,
                    //   children: station.speedDialButtons.map((e) {
                    //     return Container(
                    //       //width: double.infinity,
                    //       padding: const EdgeInsets.symmetric(horizontal: 15),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: const Color(0xFFEAECF0)),
                    //         borderRadius: BorderRadius.circular(60),
                    //       ),
                    //       child: TextButton(
                    //         onPressed: () {
                    //           station.speedButton(value: e['moneyValue']);
                    //         },
                    //         child: Text(
                    //           "${e['moneyLabel']}",
                    //           style: TextStyle(
                    //             fontFamily: 'Nunito',
                    //             fontSize: size.width * 0.036,
                    //             fontWeight: FontWeight.w800,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                    const Divider(color: Color(0xFFE9EAEB), thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          l10n.transactionFeeLabel,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.041,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          "\$ ${moneyFormat.format(station.selectedPaymentGateway?.transactionFee ?? 0)}",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.046,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          l10n.totalToPayLabel,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.041,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "\$ ${moneyFormat.format(totalToPay)}",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.046,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        await paymentRecordResponse(station, context);

                        // Aquí iría la lógica de autenticación biométrica
                        // final transactionId = await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const WompiCheckoutPage(),
                        //   ),
                        // );
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
                        l10n.continueToPayButton,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.035,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
