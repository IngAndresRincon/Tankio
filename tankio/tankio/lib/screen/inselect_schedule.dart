import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/schedule_inselect.dart';
import 'package:tankio/provider/vehicle.dart';
import 'package:tankio/utils/enum.dart';
import 'package:tankio/widget/modal/status_modal.dart';

class InselectSchedule extends ConsumerStatefulWidget {
  const InselectSchedule({super.key, required this.positionCode});
  final String positionCode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InselectScheduleState();
}

class _InselectScheduleState extends ConsumerState<InselectSchedule> {
  bool buttonIsValid = false;
  @override
  void initState() {
    initLoad();
    super.initState();
  }

  void initLoad() async {
    await Future.microtask(() async {
      await ref
          .read(vehicleProvider)
          .getListEnableVehicleByUserId(validEnable: true);
      //ref.read(tankioProvider).clearFields();
      await ref
          .read(inselectProvider)
          .getDispenserPositionByCode(code: widget.positionCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final moneyFormat = NumberFormat.decimalPattern('es_CO');
    final vehicle = ref.watch(vehicleProvider);
    final inselect = ref.watch(inselectProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF60AF47),
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
          l10n.inselectScheduleTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: !inselect.isValidBalanceGroup
          ? _buildInvalidBalanceGroupView(context, size)
          : Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                children: [
                  Text(
                    l10n.selectVehicleLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.directions_car_outlined),
                      labelText: l10n.selectVehicleDropdownLabel,
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
                    items: vehicle.vehicles.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(
                          "${e.brand.toUpperCase()} - ${e.plate.toUpperCase()}",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.036,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        inselect.controllerVehicle.text = vehicle.vehicles
                            .firstWhere((e) => e.id == int.parse(value ?? "0"))
                            .plate;
                      });
                    },
                  ),

                  const SizedBox(height: 10),
                  Text(
                    l10n.connectorTypeLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.ev_station),
                      labelText: l10n.selectFuelLabel,
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
                    items: inselect.listDispenserPosition
                        .map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            value: e.hoseId.toString(),
                            child: Text(
                              "${e.hoseNumber}-${e.product.toUpperCase()} - ${e.symbol}${moneyFormat.format(e.price)} ${e.currency}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.031,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        })
                        .toList(),
                    onChanged: (value) async {
                      setState(() {
                        inselect.selectProduct(hoseid: int.parse(value ?? "0"));
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  Text(
                    l10n.amountSectionLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            buttonIsValid = inselect.minusButton();
                          },
                          icon: Icon(
                            Icons.remove,
                            color: const Color(0xFF535862),
                            size: size.width * 0.08,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: inselect.controllerValue,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.grey.shade800,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (value) {
                              buttonIsValid = inselect.validateValueField(
                                value: value,
                              );
                              setState(() {});
                            },

                            decoration: InputDecoration(
                              //prefixIcon: Icon(Icons.lock_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              labelText: l10n.valueLabel,
                              labelStyle: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.grey.shade700,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            buttonIsValid = inselect.addButton();
                          },
                          icon: Icon(
                            Icons.add,
                            color: const Color(0xFF535862),
                            size: size.width * 0.08,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF9F9F9),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: inselect.speedDialButtons.map<Widget>((e) {
                        return TextButton(
                          onPressed: () {
                            buttonIsValid = inselect.speedButton(
                              value: e['moneyValue'].toString(),
                            );
                          },
                          child: Text(
                            "${e['moneyLabel']}",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.036,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFD5D7DA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          l10n.summaryTitle,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.036,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              l10n.moneySummaryLabel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "\$ ${moneyFormat.format(num.tryParse(inselect.moneyCalculate) ?? 0)}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.041,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              l10n.powerSummaryLabel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${inselect.powerCalculate} Watts",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.041,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              l10n.connectorNameLabel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              inselect.productSelected == null
                                  ? ''
                                  : inselect.productSelected!.product,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.041,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              l10n.rateLabel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "\$ ${moneyFormat.format(inselect.productSelected == null ? 0 : inselect.productSelected!.price)}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.041,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              l10n.estimatedTotalLabel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "\$ ${moneyFormat.format(num.tryParse(inselect.moneyCalculate) ?? 0)}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.046,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: !buttonIsValid
                        ? null
                        : () async {
                            await inselect.createProgramming().then((
                              bool? value,
                            ) {
                              if (!context.mounted) return;

                              if (value == null) {
                                AppStatusModal.show(
                                  context: context,
                                  type: AppModalType.alert,
                                  title: l10n.programmingErrorTitle,
                                  message: l10n
                                      .programmingInsufficientBalanceMessage,
                                );
                                return;
                              }
                              if (value) {
                                AppStatusModal.show(
                                  dismissible: false,
                                  onPrimaryPressed: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          if (!context.mounted) return;
                                          Navigator.of(
                                            context,
                                          ).pushReplacementNamed('/activity');
                                        });
                                  },
                                  primaryText: l10n.ok,
                                  context: context,
                                  type: AppModalType.success,
                                  title: l10n.scheduleConfirmationTitle,
                                  message: l10n.scheduleConfirmationMessage,
                                );
                              }
                              // else {
                              //   AppStatusModal.show(
                              //     context: context,
                              //     type: AppModalType.error,
                              //     title: l10n.scheduleErrorTitle,
                              //     message: l10n.scheduleErrorMessage,
                              //   );
                              // }
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
                      l10n.confirmScheduleButton,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.035,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInvalidBalanceGroupView(BuildContext context, Size size) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEAECF0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAEA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  color: Color(0xFFE53935),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.qrDoesNotBelongTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.qrDoesNotBelongMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.033,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
