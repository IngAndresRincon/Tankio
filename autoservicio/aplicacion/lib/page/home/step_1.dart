import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgrammingPage extends ConsumerWidget {
  const ProgrammingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    final bool compactLayout = size.width < 600;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      children: [
        Container(
          height: (size.height * 0.27).clamp(200.0, 260.0).toDouble(),
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFFFFF), Color(0xFFE5F6EB)],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: size.width * 0.6,
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                      ],
                      stops: [0, 0.22, 0.62, 1],
                    ).createShader(bounds);
                  },
                  child: Image.asset(
                    'assets/ev_vehicle.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    width: size.width * 0.15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Programar carga\npor dinero',
                          style: TextStyle(
                            color: Color(0xFF102B3F),
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                            fontSize: (size.width * 0.07)
                                .clamp(28.0, 36.0)
                                .toDouble(),
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ingresa el monto \nque deseas cargar.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: (size.width * 0.035)
                                .clamp(13.0, 16.0)
                                .toDouble(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD4E8DA)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120C542D),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(38, 22, 134, 89),
                          radius: size.width * 0.05,
                          child: Icon(
                            Icons.monetization_on_rounded,
                            color: Color(0xFF16865A),
                            size: size.width * 0.085,
                          ),
                        ),
                        SizedBox(width: compactLayout ? 4 : 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Método de carga",
                              style: TextStyle(
                                color: Color(0xFF708178),
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.02,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Por Dinero",
                              style: TextStyle(
                                color: Color(0xFF102B3F),
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                fontSize: size.width * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    margin: EdgeInsets.symmetric(
                      horizontal: compactLayout ? 6 : 12,
                    ),
                    color: Color(0xFFD8E7DD),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFF16865A),
                          size: size.width * 0.085,
                        ),
                        SizedBox(width: compactLayout ? 4 : 8),
                        Text(
                          'Tú eliges el monto \ny nosotros calculamos \nla energía.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.025,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    color: Color(0xFF16865A),
                    size: size.width * 0.09,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    page.controllerValue.text,
                    style: TextStyle(
                      color: Color(0xFF102B3F),
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      fontSize: size.width * 0.08,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Center(
          child: SizedBox(
            width: size.width * 0.4,
            height: size.height * 0.34,
            child: GridView.builder(
              itemCount: page.listButtonKeyBoard.length,
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return page.listButtonKeyBoard[index];
              },
            ),
          ),
        ),
        const SizedBox(height: 25),
        Container(
          width: double.infinity,
          height: size.height * 0.05,
          child: ElevatedButton(
            onPressed: () async {
              await page.createProgramming().then((value) {
                if (!context.mounted) return;
                if (value) {
                  page.controllerSecondaryPageView.nextPage(
                    duration: Duration(seconds: 1),
                    curve: Curves.linear,
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
              elevation: 5,

              backgroundColor: Color(0xFF16865A),
            ),
            child: Text(
              "Continuar",
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
    );
  }
}
