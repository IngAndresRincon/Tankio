import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/widget/modal/programming_detail.dart';

class Activity extends ConsumerStatefulWidget {
  const Activity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActivityState();
}

class _ActivityState extends ConsumerState<Activity> {
  String _formatMoney(num value) {
    return NumberFormat.decimalPattern('es_CO').format(value);
  }

  @override
  void initState() {
    loadActivities();
    super.initState();
  }

  void loadActivities() async {
    await Future.microtask(() async {
      await ref.read(userProvider).getProgrammingActivityByUser();
    });
  }

  (String, Color, IconData) _statusData(
    AppLocalizations l10n,
    dynamic statusCode,
  ) {
    switch (statusCode) {
      case 0:
        return (
          l10n.activityRegistered,
          const Color(0xFF64748B),
          Icons.edit_note_rounded,
        );
      case 1:
        return (
          l10n.activityWaiting,
          const Color(0xFF1E3A5F),
          Icons.schedule_rounded,
        );
      case 2:
        return (
          l10n.activityAuthorized,
          const Color(0xFF0F766E),
          Icons.verified_rounded,
        );
      case 3:
        return (
          l10n.activityInProgress,
          const Color(0xFF4338CA),
          Icons.sync_rounded,
        );
      case 4:
        return (
          l10n.activityCancelled,
          const Color(0xFFDC2626),
          Icons.close_rounded,
        );
      case 5:
        return (
          l10n.activityRejected,
          const Color(0xFFDC2626),
          Icons.close_rounded,
        );
      case 6:
        return (
          l10n.activityIncomplete,
          const Color(0xFFEA580C),
          Icons.warning_amber_rounded,
        );
      case 7:
        return (
          l10n.activityCompleted,
          const Color(0xFF166534),
          Icons.task_alt_rounded,
        );
      case 8:
        return (
          l10n.activityStopped,
          const Color(0xFFB91C1C),
          Icons.block_rounded,
        );
      case 9:
        return (
          l10n.activityAuthorizePayment,
          const Color(0xFF7C3AED),
          Icons.payment_rounded,
        );
      case 10:
        return (
          l10n.activityPaymentInProgress,
          const Color(0xFF0F766E),
          Icons.hourglass_top_rounded,
        );
      default:
        return (
          l10n.activityNoInformation,
          const Color(0xFF334155),
          Icons.info_outline_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async {
            await user.getRecentActivityByuser();
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: size.width * 0.06,
          ),
        ),
        title: Text(
          l10n.activityTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   Container(
        //     margin: const EdgeInsets.symmetric(horizontal: 10),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       border: Border.all(color: const Color(0xFFE9EAEB)),
        //     ),
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.filter_alt_outlined, size: size.width * 0.08),
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: const Color(0xFFF9F9F9),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: user.activityFilterOptions.map((e) {
                  return TextButton(
                    onPressed: () {
                      user.activeFilterOption(id: e['id']);
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
              itemCount: user.programminglistfilter.length,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              itemBuilder: (context, index) {
                final item = user.programminglistfilter[index];
                final status = _statusData(l10n, item.programmingStatusId);
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return ProgrammingDetailModal(programming: item);
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: CircleAvatar(
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
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                "${item.vehicleBrand} ${item.vehicleModel}",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF535862),
                                  fontSize: size.width * 0.03,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: status.$2.withValues(alpha: 0.6),
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
                              "\$ ${_formatMoney(item.programmingMoney)}",
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
    );
  }
}
