import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/provider/schedule_tankio.dart';
import 'package:tankio/provider/vehicle.dart';
import 'package:tankio/utils/money_utils.dart';

class TankioSchedule extends ConsumerStatefulWidget {
  const TankioSchedule({super.key, required this.positionCode});
  final String positionCode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TankioScheduleState();
}

class _TankioScheduleState extends ConsumerState<TankioSchedule> {
  @override
  void initState() {
    initLoad();
    super.initState();
  }

  void initLoad() async {
    await Future.microtask(() async {
      await ref.read(vehicleProvider).getListVehicleByUserId();
      ref.read(tankioProvider).clearFields();
      await ref
          .read(tankioProvider)
          .getDispenserPositionByCode(code: widget.positionCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final vehicle = ref.watch(vehicleProvider);
    final tankio = ref.watch(tankioProvider);
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
          "Tankio Schedule",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
              "Select Vehicle",
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
                labelText: 'Select vehicle',
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
                  tankio.controllerVehicle.text = vehicle.vehicles
                      .firstWhere((e) => e.id == int.parse(value ?? "0"))
                      .plate;
                });
              },
            ),

            const SizedBox(height: 10),
            Text(
              "Select Fuel",
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
                prefixIcon: Icon(Icons.local_gas_station),
                labelText: 'Select Fuel',
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
              items: tankio.listDispenserPosition.map<DropdownMenuItem<String>>((
                e,
              ) {
                return DropdownMenuItem(
                  value: e.hoseId.toString(),
                  child: Text(
                        "${e.product.toUpperCase()} - ${e.symbol}${formatMoney(e.price)} ${e.currency}",
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
                  tankio.selectProduct(hoseid: int.parse(value ?? "0"));
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Select scheduling type",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.036,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              initialValue: tankio.controllerSchedulingType.text,
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey.shade800,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) async {
                setState(() {
                  tankio.controllerSchedulingType.text = value ?? '';
                  tankio.controllerValue.text = "0";
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.type_specimen_outlined),
                labelText: 'Select Fuel',
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
              items: tankio.schedulingtype,
            ),
            const SizedBox(height: 10),
            Text(
              "Amount/Volume",
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
                    onPressed: tankio.minusButton,
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
                      controller: tankio.controllerValue,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.grey.shade800,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (value) {
                        tankio.validateValueField(value: value);
                      },
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.lock_outlined),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        labelText: 'Value',
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
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: tankio.addButton,
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
                children: tankio.speedDialButtons.map<Widget>((e) {
                  final int type = int.parse(
                    tankio.controllerSchedulingType.text,
                  );
                  return TextButton(
                    onPressed: () => tankio.speedButton(
                      value: e[type == 1 ? 'moneyValue' : 'volumeValue']
                          .toString(),
                    ),
                    child: Text(
                      "${type == 1 ? e['moneyLabel'] : e['volumeLabel']}",
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
                    "Summary",
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
                        "Money",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.036,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$ ${formatMoney(parseMoney(tankio.moneyCalculate))}",
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
                        "Volume",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.036,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${tankio.volumeCalculate} Galons",
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
                        "Product Name",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.036,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        tankio.productSelected == null
                            ? ''
                            : tankio.productSelected!.product,
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
                        "Product Price",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.036,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$ ${tankio.productSelected == null ? '' : formatMoney(tankio.productSelected!.price)}",
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
                        "Estimated Total",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.036,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$ ${formatMoney(parseMoney(tankio.moneyCalculate))}",
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
              onPressed: () async {
                await tankio.createProgramming().then((value) {
                  if (!context.mounted) return;
                  if (value) {
                    Navigator.of(context).pop();
                  }
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
                'Confirm Schedule',
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
}
