import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/vehicle.dart';
import 'package:tankio/widget/modal/edit_vehicle.dart';

class Vehicles extends ConsumerStatefulWidget {
  const Vehicles({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VehiclesState();
}

class _VehiclesState extends ConsumerState<Vehicles> {
  @override
  void initState() {
    loadvehicles();
    super.initState();
  }

  void loadvehicles() async {
    await Future.microtask(() async {
      await ref.read(vehicleProvider).getListVehicleByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final vehicle = ref.watch(vehicleProvider);
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
          l10n.myVehiclesTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE9EAEB)),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-vehicles');
              },
              icon: Icon(Icons.add, size: size.width * 0.08),
            ),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await ref.read(vehicleProvider).getListEnableVehicleByUserId();
        },
        backgroundColor: Colors.black12,
        height: size.height * 0.1,
        color: Colors.white,
        showChildOpacityTransition: true,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: vehicle.vehicles.length,
          itemBuilder: (context, index) {
            final item = vehicle.vehicles[index];

            return Dismissible(
              key: Key(item.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      l10n.deleteAction,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade600,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                    const SizedBox(width: 8),

                    Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red.shade600,
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) async {
                await vehicle.deleteVehicle(vehicleid: item.id);
                //notification.deleteItemNotificationFromList(item.id);
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.directions_car_rounded,
                        color: Colors.grey.shade300,
                        size: size.width * 0.15,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "${item.brand} ${item.model}",
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: Colors.black,
                                        fontSize: size.width * 0.036,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      "${l10n.plateLabel}: ${item.plate}",
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: const Color(0xFF535862),
                                        fontSize: size.width * 0.031,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      item.enable
                                          ? l10n.vehicleEnabledLabel
                                          : l10n.vehicleDisabledLabel,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: item.enable
                                            ? Colors.green.shade400
                                            : const Color(0xFFC0C0C0),
                                        fontSize: size.width * 0.034,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    vehicle.controllerVehiclePlateNumber.text =
                                        item.plate;
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) {
                                        return EditVehicleModal(
                                          vehicle: vehicle.vehicles[index],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xFF0E240E),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 2,
                                    ),
                                  ),
                                  child: Text(
                                    l10n.editButton,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontSize: size.width * 0.031,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xB8F6F6F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${item.connector} | ${item.description}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: const Color(0xFF535862),
                                fontSize: size.width * 0.031,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
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
