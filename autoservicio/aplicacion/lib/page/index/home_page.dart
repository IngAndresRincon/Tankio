import 'package:aplicacion/page/home/step_1.dart';
import 'package:aplicacion/page/home/step_2.dart';
import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final page = ref.watch(pageProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFF2FBF5), Color(0xFFE0F3E7)],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.1,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      page.controllerMainPageView.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Easing.legacy,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: const Color(0xFF12372D),
                      size: size.width * 0.1,
                    ),
                  ),

                  ElevatedButton.icon(
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
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: PageView(
                  controller: page.controllerSecondaryPageView,
                  children: [Step1Page(), Step2Page()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
