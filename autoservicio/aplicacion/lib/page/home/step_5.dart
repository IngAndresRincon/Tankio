import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElectricChargingProcess extends ConsumerStatefulWidget {
  const ElectricChargingProcess({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ElectricChargingProcessState();
}

class _ElectricChargingProcessState
    extends ConsumerState<ElectricChargingProcess> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/ev_charging_station.png', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x77213E50), Color(0xAA1C3546)],
            ),
          ),
        ),
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 40),
          children: [
            SizedBox(height: size.height * 0.15),
            Text(
              'Carga en proceso',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFF102B3F),
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: (size.width * 0.07).clamp(28.0, 36.0).toDouble(),
                height: 1.05,
              ),
            ),
            Text(
              'Monitorea el estado de tu carga en tiempo real.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey.shade200,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: (size.width * 0.035).clamp(13.0, 16.0).toDouble(),
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black26),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Indicador circular
                        const SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: 0.68,
                            backgroundColor: Color(0xFFE7F7EF),
                            color: Color(0xFF31B76F),
                            strokeWidth: 12,
                            strokeCap: StrokeCap.round,
                          ),
                        ),

                        // Porcentaje centrado
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "68%",
                              style: TextStyle(
                                color: Color(0xFF071631),
                                fontFamily: 'Nunito',
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "Cargando",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.bolt,
                              color: Color(0xFF31B76F),
                              size: 28,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: size.width * 0.05,
                              backgroundColor: const Color(0xFFd6f2e2),
                              child: Icon(
                                Icons.bolt,
                                color: const Color(0xFF35a315),
                                size: size.width * 0.06,
                              ),
                            ),
                            const SizedBox(width: 5),

                            Text(
                              "Carga activa \nen proceso",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.03,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFeaf7f1),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: size.width * 0.05,
                                backgroundColor: const Color(0xFFccf3dc),
                                child: Image.asset(
                                  "assets/leaf.png",
                                  width: size.width * 0.06,
                                ),
                              ),
                              const SizedBox(width: 5),

                              Text(
                                "Tu vehículo se está cargando\ncon energía limpia y renovable.",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Nunito',
                                  fontSize: size.width * 0.02,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black26),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.05,
                        backgroundColor: const Color(0xFFd6f2e2),
                        child: Icon(
                          Icons.bar_chart_rounded,
                          color: const Color(0xFF35a315),
                          size: size.width * 0.06,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Datos en tiempo real",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.25,
                    child: GridView.builder(
                      itemCount: page.electricLoadData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        final item = page.electricLoadData[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(item['icon'], size: size.width * 0.06),
                                  Text(
                                    "${item['label']}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: size.width * 0.025,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${item['value']}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.07,
              child: ElevatedButton.icon(
                onPressed: () async {
                  page.controllerSecondaryPageView.previousPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xFFe45451),
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                label: Text(
                  "Finalizar carga",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.034,
                  ),
                ),
                icon: Icon(
                  Icons.stop_circle_outlined,
                  size: size.width * 0.06,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
