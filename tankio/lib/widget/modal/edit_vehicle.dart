import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/models/vehicle_by_user_id.dart';
import 'package:tankio/provider/vehicle.dart';

class EditVehicleModal extends ConsumerStatefulWidget {
  final VehicleModel vehicle;
  const EditVehicleModal({super.key, required this.vehicle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditVehicleModelState();
}

class _EditVehicleModelState extends ConsumerState<EditVehicleModal> {
  bool isEnable = true;

  @override
  void initState() {
    isEnable = widget.vehicle.enable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final vehicle = ref.watch(vehicleProvider);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.4,
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
                      l10n.activeVehicleTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          isEnable = !isEnable;
                          setState(() {});
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              l10n.setEnableAsDefaultLabel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.031,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            isEnable
                                ? Icon(
                                    Icons.radio_button_checked_rounded,
                                    color: Colors.green.shade600,
                                    size: size.width * 0.08,
                                  )
                                : Icon(
                                    Icons.radio_button_off_rounded,
                                    color: Colors.grey.shade300,
                                    size: size.width * 0.08,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        await vehicle
                            .updateEnableVehicle(
                              id: widget.vehicle.id,
                              active: isEnable,
                            )
                            .then((value) {
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
                        l10n.saveChangesButton,
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
      },
    );
  }
}
