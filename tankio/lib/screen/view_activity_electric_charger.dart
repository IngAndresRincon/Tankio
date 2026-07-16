import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/schedule_inselect.dart';
import 'package:tankio/utils/money_utils.dart';

class ActivityElectricCharger extends ConsumerStatefulWidget {
  const ActivityElectricCharger({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<ActivityElectricCharger> {
  @override
  void initState() {
    initDataCharger();
    super.initState();
  }

  void initDataCharger() async {
    await Future.microtask(() {
      ref.read(inselectProvider).clearFieldCharger();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inselect = ref.watch(inselectProvider);
    final l10n = AppLocalizations.of(context)!;
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
          l10n.chargingProcessTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.3,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentGeometry.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${(inselect.electricChargePercentage * 100).toStringAsFixed(2)} %",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.056,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        inselect.statusChager ?? "",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.031,
                          fontWeight: FontWeight.w600,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: size.width * 0.030,
                    strokeAlign: 15,
                    strokeCap: StrokeCap.round,
                    value: inselect.electricChargePercentage,
                    color: Colors.green.shade300,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              children: [
                Center(
                  child: Text(
                    inselect.uuidProgramming ?? "NA",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  height: 0.05,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.sessionDetailsTitle,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: size.width * 0.041,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(Icons.data_thresholding_rounded),
                  ),
                  title: Text(
                    l10n.currentLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  trailing: Text(
                    "${inselect.currentValue} A",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(Icons.data_thresholding_rounded),
                  ),
                  title: Text(
                    l10n.voltageLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  trailing: Text(
                    "${inselect.voltageValue} V",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(Icons.electric_bolt_rounded),
                  ),
                  title: Text(
                    l10n.powerLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  trailing: Text(
                    "${inselect.powerValue} Watts",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(Icons.attach_money_rounded),
                  ),
                  title: Text(
                    l10n.estimatedCostLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF535862),
                    ),
                  ),
                  trailing: Text(
                    "\$ ${formatMoney(inselect.estimatedCost)}",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.041,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed:
                      inselect.uuidProgramming == null ||
                          inselect.programmingStatusId != 3
                      ? null
                      : () async {
                          final uuid = inselect.uuidProgramming ?? "";
                          await inselect.changeStatusProgramming(uuid, 8).then((
                            value,
                          ) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
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
                    l10n.stopChargingButton,
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
        ],
      ),
    );
  }
}
