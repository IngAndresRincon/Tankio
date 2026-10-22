import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step1Page extends ConsumerWidget {
  const Step1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    final bool compactLayout = size.width < 600;
    final double keyboardSpacing = compactLayout ? 10 : 14;
    final double keyboardWidth = (size.width * (compactLayout ? 0.58 : 0.42))
        .clamp(250.0, 380.0)
        .toDouble();
    final double keyboardHeight =
        ((keyboardWidth - keyboardSpacing * 2) / 3 * 4) + (keyboardSpacing * 3);

    return ListView(
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
                width: size.width * 0.68,
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: compactLayout ? 0.60 : 0.56,
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
                          'Ingresa el monto que deseas cargar.',
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
        const SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: compactLayout ? 12 : 20,
            vertical: compactLayout ? 10 : 13,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(60),
            border: Border.all(color: const Color(0xFFD4E8DA)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120C542D),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: compactLayout
              ? Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color.fromARGB(38, 22, 134, 89),
                          radius: 20,
                          child: Icon(
                            Icons.monetization_on_rounded,
                            color: Color(0xFF16865A),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Método de carga',
                              style: TextStyle(
                                color: Color(0xFF708178),
                                fontFamily: 'Nunito',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'Por dinero',
                              style: TextStyle(
                                color: Color(0xFF102B3F),
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFD8E7DD)),
                    const Row(
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFF62D6B2),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tú eliges el monto y nosotros calculamos la energía.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(38, 22, 134, 89),
                            radius: compactLayout ? 13 : 20,
                            child: Icon(
                              Icons.monetization_on_rounded,
                              color: Color(0xFF16865A),
                              size: compactLayout ? 20 : 26,
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
                                  fontSize: compactLayout ? 11 : 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Por Dinero",
                                style: TextStyle(
                                  color: Color(0xFF102B3F),
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800,
                                  fontSize: compactLayout ? 14 : 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
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
                            size: compactLayout ? 18 : 24,
                          ),
                          SizedBox(width: compactLayout ? 4 : 8),
                          Text(
                            'Tú eliges el monto \ny nosotros calculamos \nla energía.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 25),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: compactLayout ? 16 : 24,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            border: Border.all(color: Color(0xFFD4E8DA)),
            borderRadius: BorderRadius.circular(60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.attach_money_rounded,
                color: Color(0xFF16865A),
                size: size.width * 0.06,
                weight: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    page.controllerValue.text,
                    style: TextStyle(
                      color: Color(0xFF102B3F),
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      fontSize: (size.width * 0.09)
                          .clamp(36.0, 48.0)
                          .toDouble(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: SizedBox(
            width: keyboardWidth,
            height: keyboardHeight,
            child: GridView.builder(
              itemCount: page.listButtonKeyBoard.length,
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: keyboardSpacing,
                mainAxisSpacing: keyboardSpacing,
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
