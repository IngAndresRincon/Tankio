import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingPaymentPage extends ConsumerWidget {
  const LoadingPaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/backgroun_payment.png', fit: BoxFit.cover),
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
              'Realiza el pago en el datáfono',
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
              'Sigue las intrucciones \npara completar el pago.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade200,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: (size.width * 0.035).clamp(13.0, 16.0).toDouble(),
              ),
            ),
            SizedBox(height: size.height * 0.3),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                        backgroundColor: const Color(0xFF2ccf7c),
                        radius: size.width * 0.04,
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "Esperando \npago",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF2ccf7c),
                        radius: size.width * 0.04,
                        child: Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "Procesando \npago",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF2ccf7c),
                        radius: size.width * 0.04,
                        child: Text(
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "Confirmando \ncarga",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                page.controllerSecondaryPageView.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear,
                );
              },
              child: Container(
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
                        Icons.payment,
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
                            "Puedes pagar con",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.02,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Tarjeta débito o crédito",
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "Aproxima, inserta o desliza tu tarjeta en el datáfono.",
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
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.05,
              child: ElevatedButton(
                onPressed: () async {
                  page.controllerSecondaryPageView.previousPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xFFbd1619),
                ),
                child: Text(
                  "Cancelar proceso",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.034,
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
