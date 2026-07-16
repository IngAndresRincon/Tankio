import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/vehicle.dart';
import 'package:tankio/utils/enum.dart';
import 'package:tankio/widget/modal/status_modal.dart';

class AddVehicle extends ConsumerStatefulWidget {
  const AddVehicle({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddVehicleState();
}

class _AddVehicleState extends ConsumerState<AddVehicle> {
  bool isVehicleElectric = false;

  @override
  void initState() {
    super.initState();
    loadvehicleType();
  }

  void loadvehicleType() async {
    await Future.microtask(() async {
      await ref.read(vehicleProvider).getListVehicleType();
      await ref.read(vehicleProvider).getListVehicleConnector();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final vehicle = ref.watch(vehicleProvider);

    String? safeDropdownValue(
      List<DropdownMenuItem<String>> items,
      String text,
    ) {
      if (text.isEmpty) return null;
      final matches = items.where((item) => item.value == text).length;
      return matches == 1 ? text : null;
    }

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
          l10n.addVehiclesTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        children: [
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: size.width * 0.6,
              height: size.width * 0.6,
              child: Image.asset('assets/add-vehicle.png', width: 130),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              l10n.addVehicleDetailsTitle,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.041,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Center(
            child: Text(
              l10n.addVehicleSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.036,
                color: const Color(0xFF535862),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: const Color(0xFFF9F9F9),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: isVehicleElectric,
                  child: TextButton(
                    onPressed: () {
                      isVehicleElectric = false;
                      vehicle.controllerVehicleConnector.text = '';

                      setState(() {});
                    },
                    child: Text(
                      l10n.fuelLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF535862),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isVehicleElectric,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black12,
                          offset: Offset(1, 1),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.fuelLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isVehicleElectric,
                  child: TextButton(
                    onPressed: () {
                      isVehicleElectric = true;
                      setState(() {});
                    },
                    child: Text(
                      l10n.electricLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF535862),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isVehicleElectric,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black12,
                          offset: Offset(1, 1),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.electricLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.plateNumberLabel,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.036,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.grey.shade800,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
            maxLength: 6,
            controller: vehicle.controllerVehiclePlateNumber,
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              labelText: l10n.vehicleLabel,
              labelStyle: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey.shade700,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w300,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.vehicleTypeTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.036,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: safeDropdownValue(
              vehicle.listVehicleType,
              vehicle.controllerVehicleType.text,
            ),
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.grey.shade800,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),

            decoration: InputDecoration(
              prefixIcon: Icon(Icons.directions_car_outlined),
              labelText: l10n.selectVehicleTypeLabel,
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
            items: vehicle.listVehicleType,
            onChanged: (value) async {
              setState(() {
                vehicle.controllerVehicleType.text = value ?? '';
                vehicle.controllerVehicleBrand.clear();
                vehicle.controllerVehicleModel.clear();
                vehicle.listVehicleBrand.clear();
                vehicle.listVehicleModel.clear();
              });
              await vehicle.getListVehicleBrand();
            },
          ),
          const SizedBox(height: 10),
          Text(
            l10n.vehicleBrandTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.036,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: safeDropdownValue(
              vehicle.listVehicleBrand,
              vehicle.controllerVehicleBrand.text,
            ),
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.grey.shade800,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),

            decoration: InputDecoration(
              prefixIcon: Icon(Icons.local_offer_outlined),
              labelText: l10n.selectBrandLabel,
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
            items: vehicle.listVehicleBrand,
            onChanged: (value) async {
              setState(() {
                vehicle.controllerVehicleBrand.text = value ?? '';
                vehicle.controllerVehicleModel.clear();
                vehicle.listVehicleModel.clear();
              });
              await vehicle.getListVehicleModel();
            },
          ),

          const SizedBox(height: 10),
          Text(
            l10n.vehicleModelTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.036,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: safeDropdownValue(
              vehicle.listVehicleModel,
              vehicle.controllerVehicleModel.text,
            ),
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.grey.shade800,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),

            decoration: InputDecoration(
              prefixIcon: Icon(Icons.view_module_outlined),
              labelText: l10n.selectModelLabel,
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
            items: vehicle.listVehicleModel,
            onChanged: (value) {
              setState(() {
                vehicle.controllerVehicleModel.text = value ?? '';
              });
            },
          ),

          const SizedBox(height: 10),

          Visibility(
            visible: isVehicleElectric,
            child: Text(
              l10n.connectorTypeTitle,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.036,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Visibility(
            visible: isVehicleElectric,
            child: DropdownButtonFormField<String>(
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey.shade800,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w600,
              ),

              decoration: InputDecoration(
                prefixIcon: Icon(Icons.electrical_services_rounded),
                labelText: l10n.selectConnectorLabel,
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
              items: vehicle.listVehicleConnector,
              onChanged: (value) {
                setState(() {
                  vehicle.controllerVehicleConnector.text = value ?? '';
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              AppStatusModal.show(
                context: context,
                type: AppModalType.loading,
                title: l10n.addVehiclesTitle,
                message: l10n.waitAMomentMessage,
                dismissible: false,
              );

              await vehicle.registerNewVehicle().then((value) {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                if (value) {
                  AppStatusModal.show(
                    context: context,
                    type: AppModalType.success,
                    title: "Vehiculo",
                    message: "Vehículo registrado correctamente.",
                  ).then((value) {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  });
                } else {
                  AppStatusModal.show(
                    context: context,
                    type: AppModalType.error,
                    title: "Vehiculo",
                    message:
                        "Error registrando el vehículo, valide la información.",
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF60AF47),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              l10n.saveVehicleButton,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.035,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
