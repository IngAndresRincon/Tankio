import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step2Page extends ConsumerWidget {
  const Step2Page({super.key});

  static const Color primaryText = Color(0xFF102B3F);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color accent = Color(0xFF16865A);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFD4E8DA);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    final bool compactLayout = size.width < 600;
    final String amountText = page.controllerValue.text.isEmpty
        ? '0'
        : page.controllerValue.text;
    final String formattedAmount = amountText.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
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
                          'Resumen de compra',
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
                          'Verifica los datos antes de continuar.',
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
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120C542D),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: accent.withValues(alpha: 0.16),
                    radius: size.width * 0.05,
                    child: Icon(
                      Icons.bolt,
                      color: accent,
                      size: size.width * 0.08,
                    ),
                  ),

                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Detalle de carga',
                      style: TextStyle(
                        color: primaryText,
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      page.controllerSecondaryPageView.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: accent,
                      backgroundColor: const Color(0xFFEAF7EE),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(
                      'Editar',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: accent,
                        fontSize: size.width * 0.025,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FCF9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: accent.withValues(alpha: 0.15),
                      radius: size.width * 0.05,
                      child: Icon(
                        Icons.attach_money,
                        color: accent,
                        size: size.width * 0.07,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monto ingresado',
                            style: TextStyle(
                              color: secondaryText,
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.025,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Wrap(
                            spacing: 6,
                            children: [
                              Text(
                                '\$ $formattedAmount',
                                style: TextStyle(
                                  color: primaryText,
                                  fontFamily: 'Nunito',
                                  fontSize: compactLayout ? 23 : 27,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                'COP',
                                style: TextStyle(
                                  color: secondaryText,
                                  fontFamily: 'Nunito',
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!compactLayout)
                      SizedBox(
                        width: 132,
                        child: Text(
                          'Con este monto se iniciará la carga.',
                          style: TextStyle(
                            color: secondaryText,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.02,
                            height: 1.25,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 9),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FCF9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0x223B9CFF),
                      radius: size.width * 0.05,
                      child: Icon(
                        Icons.bar_chart_rounded,
                        color: Color(0xFF75B9FF),
                        size: size.width * 0.07,
                      ),
                    ),

                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Valor del kWh',
                            style: TextStyle(
                              color: secondaryText,
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.025,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Por confirmar',
                            style: TextStyle(
                              color: primaryText,
                              fontFamily: 'Nunito',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!compactLayout)
                      SizedBox(
                        width: 132,
                        child: Text(
                          'Tarifa por energía en esta estación.',
                          style: TextStyle(
                            color: secondaryText,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.02,
                            height: 1.25,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 9),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FCF9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: accent.withValues(alpha: 0.15),
                      radius: size.width * 0.05,
                      child: Icon(
                        Icons.electric_bolt,
                        color: accent,
                        size: size.width * 0.07,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Potencia a entregar',
                            style: TextStyle(
                              color: secondaryText,
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.025,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Se calculará al confirmar',
                            style: TextStyle(
                              color: primaryText,
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!compactLayout)
                      SizedBox(
                        width: 132,
                        child: Text(
                          'Energía estimada con el monto ingresado.',
                          style: TextStyle(
                            color: secondaryText,
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.02,
                            height: 1.25,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.battery_charging_full, color: accent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Producto: Energía',
                      style: TextStyle(
                        color: primaryText,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: size.width * 0.02,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0x223B9CFF),
              radius: size.width * 0.05,
              child: Icon(
                Icons.credit_card,
                color: Color(0xFF75B9FF),
                size: size.width * 0.07,
              ),
            ),

            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forma de pago',
                    style: TextStyle(
                      color: primaryText,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: size.width * 0.025,
                    ),
                  ),
                  Text(
                    'Confirma el método de pago para continuar.',
                    style: TextStyle(
                      color: secondaryText,
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.02,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7EE),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/terminal_payment.gif',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Datáfono',
                      style: TextStyle(
                        color: primaryText,
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Paga de forma segura en la estación con tarjeta débito o crédito.',
                      style: TextStyle(
                        color: secondaryText,
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.02,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.radio_button_checked, color: accent, size: 25),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
              "Continuar y pagar",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: size.width * 0.034,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }
}
