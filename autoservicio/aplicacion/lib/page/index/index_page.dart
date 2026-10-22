import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage> {
  static const Color navy = Color(0xFFF2F7FA);
  static const Color green = Color(0xFF62D6B2);
  static const Color muted = Color(0xFFB2C1CC);
  double valueSlider = 0;
  bool isContinuing = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background_ev.png', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x77213E50), Color(0xAA1C3546)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: ListView(
              children: [
                Align(
                  alignment: AlignmentGeometry.centerEnd,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    iconAlignment: IconAlignment.start,
                    icon: Icon(
                      Icons.help_outline_rounded,
                      color: Colors.black,
                      size: size.width * 0.04,
                    ),
                    label: Text(
                      "Ayuda",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        fontSize: size.width * 0.025,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: size.width * 0.12,
                    color: const Color(0xFF192b4b),
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    text: 'Estás en el sistema \nautoservicio para ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: size.width * 0.06,
                      color: const Color(0xFF192b4b),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'EV',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.06,
                          color: const Color(0xFF26c07e),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Programa tu carga de forma \nrápida, segura y sencilla",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.04,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: size.height * 0.3),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFeaf9ec),
                            radius: size.width * 0.05,
                            child: Image.asset(
                              "assets/leaf.png",
                              width: size.width * 0.08,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Carga en autoservicio",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800,
                                  fontSize: size.width * 0.03,
                                  color: const Color(0xFF030a2b),
                                ),
                              ),
                              Text(
                                "Tu controlas tu tiempo, de forma fácil y segura.",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * 0.025,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFe3eefd),
                                radius: size.width * 0.05,
                                child: Icon(
                                  Icons.bolt_outlined,
                                  color: const Color(0xFF1e79e5),
                                  size: size.width * 0.08,
                                ),
                              ),
                              Text(
                                "Rápido",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800,
                                  fontSize: size.width * 0.025,
                                  color: const Color(0xFF030a2b),
                                ),
                              ),
                              Text(
                                "Inicia tu carga \nen pocos pasos.",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * 0.02,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 2,
                            height: 100,
                            color: Colors.grey.shade300,
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFe8f8f0),
                                radius: size.width * 0.05,
                                child: Icon(
                                  Icons.security_rounded,
                                  color: const Color(0xFF47bd65),
                                  size: size.width * 0.08,
                                ),
                              ),
                              Text(
                                "Seguro",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800,
                                  fontSize: size.width * 0.025,
                                  color: const Color(0xFF030a2b),
                                ),
                              ),
                              Text(
                                "Pagos protegidos \ny confiables",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * 0.02,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 2,
                            height: 100,
                            color: Colors.grey.shade300,
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFeaf9ec),
                                radius: size.width * 0.05,
                                child: Image.asset(
                                  "assets/leaf.png",
                                  width: size.width * 0.08,
                                ),
                              ),

                              Text(
                                "Sencillo",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800,
                                  fontSize: size.width * 0.025,
                                  color: const Color(0xFF030a2b),
                                ),
                              ),
                              Text(
                                "Una experiencia \ndiseñada para ti.",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * 0.02,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SlideToContinue(
                  onCompleted: () {
                    page.controllerMainPageView.nextPage(
                      duration: const Duration(seconds: 1),
                      curve: Curves.linear,
                    );
                  },
                ),
              ],
            ),
          ),

          // SafeArea(
          //   child: LayoutBuilder(
          //     builder: (context, constraints) {
          //       final bool wideScreen = constraints.maxWidth >= 700;

          //       return Padding(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: wideScreen ? 56 : 28,
          //           vertical: 26,
          //         ),
          //         child: Column(
          //           children: [
          //             Row(
          //               children: [
          //                 Container(
          //                   width: 60,
          //                   height: 60,
          //                   decoration: BoxDecoration(
          //                     color: const Color(0xFF173B4A),
          //                     borderRadius: BorderRadius.circular(60),
          //                   ),
          //                   child: Icon(
          //                     Icons.bolt_rounded,
          //                     color: Colors.white,
          //                     size: size.width * 0.06,
          //                   ),
          //                 ),
          //                 const SizedBox(width: 12),
          //                 const Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       'AUTOSERVICIO ELÉCTRICO',
          //                       style: TextStyle(
          //                         fontFamily: 'Nunito',
          //                         color: navy,
          //                         fontSize: 15,
          //                         fontWeight: FontWeight.w800,
          //                         letterSpacing: 1,
          //                       ),
          //                     ),
          //                     SizedBox(height: 3),
          //                     Text(
          //                       'Carga simple, energía para tu camino',
          //                       style: TextStyle(
          //                         fontFamily: 'Nunito',
          //                         color: muted,
          //                         fontSize: 13,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //             Expanded(
          //               child: Center(
          //                 child: SingleChildScrollView(
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Container(
          //                         width: wideScreen ? 172 : 142,
          //                         height: wideScreen ? 172 : 142,
          //                         decoration: BoxDecoration(
          //                           color: const Color(0xFF173B3C),
          //                           shape: BoxShape.circle,
          //                           border: Border.all(
          //                             color: const Color(0xFF28534F),
          //                             width: 1,
          //                           ),
          //                         ),
          //                         child: Icon(
          //                           Icons.electric_car_rounded,
          //                           color: green,
          //                           size: wideScreen ? 94 : 76,
          //                         ),
          //                       ),
          //                       const SizedBox(height: 34),
          //                       Text(
          //                         'Bienvenido',
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           fontFamily: 'Nunito',
          //                           color: navy,
          //                           fontSize: wideScreen ? 46 : 38,
          //                           fontWeight: FontWeight.w800,
          //                           letterSpacing: -1,
          //                         ),
          //                       ),
          //                       const SizedBox(height: 12),

          //                       const Text(
          //                         'Estamos listos para acompañarte en tu carga.',
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           fontFamily: 'Nunito',
          //                           color: muted,
          //                           fontSize: 16,
          //                           height: 1.5,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),

          //             Column(
          //               children: [
          //                 Container(
          //                   width: size.width * 0.8,
          //                   height: size.height * 0.07,
          //                   padding: const EdgeInsets.symmetric(
          //                     horizontal: 30,
          //                     vertical: 30,
          //                   ),
          //                   decoration: BoxDecoration(
          //                     color: const Color(0xFF142A39),
          //                     borderRadius: BorderRadius.circular(60),
          //                     border: Border.all(
          //                       color: const Color(0xFF355263),
          //                     ),
          //                   ),
          //                   child: SliderTheme(
          //                     data: SliderTheme.of(context).copyWith(
          //                       activeTrackColor: green,
          //                       inactiveTrackColor: const Color(0xFF355263),
          //                       thumbColor: green,
          //                       overlayColor: green.withValues(alpha: 0.16),
          //                       trackHeight: 40,
          //                       thumbShape: const RoundSliderThumbShape(
          //                         enabledThumbRadius: 30,
          //                       ),
          //                       overlayShape: const RoundSliderOverlayShape(
          //                         overlayRadius: 40,
          //                       ),
          //                     ),
          //                     child: Slider(
          //                       min: 0,
          //                       max: 1,
          //                       value: valueSlider,
          //                       onChanged: isContinuing
          //                           ? null
          //                           : (value) {
          //                               setState(() {
          //                                 valueSlider = value;
          //                               });

          //                               if (valueSlider >= 0.8 &&
          //                                   !isContinuing) {
          //                                 isContinuing = true;
          //                                 page.controllerMainPageView.nextPage(
          //                                   duration: const Duration(
          //                                     seconds: 1,
          //                                   ),
          //                                   curve: Curves.linear,
          //                                 );
          //                               }
          //                             },
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Text(
          //                   isContinuing
          //                       ? 'Continuando…'
          //                       : 'Desliza para continuar',
          //                   style: TextStyle(
          //                     fontFamily: 'Nunito',
          //                     color: muted,
          //                     fontSize: size.width * 0.025,
          //                   ),
          //                 ),
          //               ],
          //             ),

          //             // Column(
          //             //   children: [
          //             //     Container(
          //             //       width: 80,
          //             //       height: 80,
          //             //       decoration: BoxDecoration(
          //             //         color: const Color(0xFF142A39),
          //             //         shape: BoxShape.circle,
          //             //         border: Border.all(color: const Color(0xFF29414F)),
          //             //       ),
          //             //       child: Icon(
          //             //         Icons.swipe_rounded,
          //             //         color: green,
          //             //         size: size.width * 0.065,
          //             //       ),
          //             //     ),
          //             //     const SizedBox(height: 10),
          //             //     const Text(
          //             //       'Desliza para continuar',
          //             //       style: TextStyle(
          //             //         fontFamily: 'Nunito',
          //             //         color: navy,
          //             //         fontSize: 16,
          //             //         fontWeight: FontWeight.w700,
          //             //       ),
          //             //     ),
          //             //     const SizedBox(height: 4),
          //             //     const Text(
          //             //       'Desliza la pantalla para comenzar',
          //             //       style: TextStyle(
          //             //         fontFamily: 'Nunito',
          //             //         color: muted,
          //             //         fontSize: 13,
          //             //       ),
          //             //     ),
          //             //   ],
          //             // ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SlideToContinue extends StatefulWidget {
  final VoidCallback onCompleted;
  final String text;
  final double height;

  const SlideToContinue({
    super.key,
    required this.onCompleted,
    this.text = 'Desliza para continuar',
    this.height = 76,
  });

  @override
  State<SlideToContinue> createState() => _SlideToContinueState();
}

class _SlideToContinueState extends State<SlideToContinue> {
  double _position = 0;
  bool _completed = false;

  static const double _padding = 5;

  @override
  Widget build(BuildContext context) {
    final double knobSize = widget.height - (_padding * 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxPosition =
            (constraints.maxWidth - knobSize - (_padding * 2)).clamp(
              0.0,
              double.infinity,
            );

        void updatePosition(double delta) {
          if (_completed) return;

          setState(() {
            _position = (_position + delta).clamp(0.0, maxPosition);
          });
        }

        void finishSlide() {
          if (_completed) return;

          if (maxPosition > 0 && _position >= maxPosition * 0.90) {
            setState(() {
              _position = maxPosition;
              _completed = true;
            });

            widget.onCompleted();
          } else {
            setState(() {
              _position = 0;
            });
          }
        }

        return Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [Color(0xFF7BDD46), Color(0xFF17AD80), Color(0xFF20B4AC)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF13A878).withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Texto e indicador
              Padding(
                padding: const EdgeInsets.only(left: 76, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.keyboard_double_arrow_right,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ],
                ),
              ),

              // Botón circular deslizable
              AnimatedPositioned(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                left: _padding + _position,
                top: _padding,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    updatePosition(details.delta.dx);
                  },
                  onHorizontalDragEnd: (_) {
                    finishSlide();
                  },
                  onHorizontalDragCancel: finishSlide,
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF17AD80),
                      size: 34,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
