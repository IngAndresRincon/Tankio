import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartElectricCharging extends ConsumerWidget {
  const StartElectricCharging({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/background_ev_charger.png', fit: BoxFit.cover),
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
              'Proceso completado',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF102B3F),
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: (size.width * 0.07).clamp(28.0, 36.0).toDouble(),
                height: 1.05,
              ),
            ),
            Text(
              'Presiona el botón para iniciar la carga.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade200,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: (size.width * 0.035).clamp(13.0, 16.0).toDouble(),
              ),
            ),
            SizedBox(height: size.height * 0.25),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFe3f1ee),
                    radius: size.width * 0.06,
                    child: Icon(
                      Icons.check_circle,
                      size: size.width * 0.08,
                      color: const Color(0xFF00c16b),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade400,
                    height: 40,
                    width: 2,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Pago confirmado",
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "El cargador está listo para usar.",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.025,
                            fontWeight: FontWeight.w600,
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFe2f6f1),
                        radius: size.width * 0.05,
                        child: Icon(
                          Icons.attach_money_rounded,
                          color: const Color(0xFF03b56a),
                          fontWeight: FontWeight.w600,
                          size: size.width * 0.06,
                        ),
                      ),
                      Text(
                        "Monto pagado",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.025,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$ 35.000 COP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Container(color: Colors.grey.shade400, width: 1, height: 100),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFe2f6f1),
                        radius: size.width * 0.05,
                        child: Icon(
                          Icons.payment,
                          color: const Color(0xFF03b56a),
                          fontWeight: FontWeight.w600,
                          size: size.width * 0.06,
                        ),
                      ),
                      Text(
                        "Método de pago",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.025,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Datáfono",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Container(color: Colors.grey.shade400, width: 1, height: 100),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFe2f6f1),
                        radius: size.width * 0.05,
                        child: Icon(
                          Icons.bolt,
                          color: const Color(0xFF03b56a),
                          fontWeight: FontWeight.w600,
                          size: size.width * 0.06,
                        ),
                      ),
                      Text(
                        "Estado",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.025,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Listo para cargar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF0f9437),
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: size.height * 0.07,
              child: ElevatedButton.icon(
                onPressed: () async {
                  page.controllerSecondaryPageView.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xFF02b27c),
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                label: Text(
                  "Iniciar carga",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.034,
                  ),
                ),
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: size.width * 0.05,
                  child: Icon(
                    Icons.bolt,
                    size: size.width * 0.06,
                    color: const Color(0xFF1fce81),
                  ),
                ),
              ),
            ),

            TextButton.icon(
              onPressed: null,
              icon: Icon(
                Icons.info_outline,
                color: const Color.fromARGB(255, 10, 43, 164),
                size: size.width * 0.04,
              ),
              label: Text(
                "La carga comenzará inmediatamente al presionar el botón.",
                style: TextStyle(
                  color: const Color.fromARGB(255, 10, 43, 164),
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.022,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Center(
              child: SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.05,
                child: OutlinedButton(
                  onPressed: () async {
                    page.controllerSecondaryPageView.previousPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: const Color.fromARGB(255, 10, 43, 164),
                    ),
                  ),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.034,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
