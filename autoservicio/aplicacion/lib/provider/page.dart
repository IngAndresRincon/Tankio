import 'package:aplicacion/main.dart';
import 'package:aplicacion/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageProvider extends ChangeNotifier {
  Ref ref;
  Size size;
  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  PageProvider({required this.ref, required this.size});

  final controllerValue = TextEditingController(text: "0");
  int indexMainPage = 0;
  int indexSecondaryPage = 0;
  final controllerMainPageView = PageController(initialPage: 0);
  final controllerSecondaryPageView = PageController(initialPage: 0);

  //Listas
  List<Widget> get listButtonKeyBoard => List.generate(12, (index) {
    if (index == 9) {
      return const SizedBox.shrink();
    }
    if (index == 10) {
      return _keyboardButton(
        index: index,
        child: Text("0", style: _keyTextStyle),
      );
    }
    if (index == 11) {
      return _keyboardButton(
        index: index,
        child: Icon(
          Icons.backspace_outlined,
          size: _keyIconSize,
          color: const Color(0xFF285A48),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return _keyboardButton(
      index: index,
      child: Text("${index + 1}", style: _keyTextStyle),
    );
  });

  List<dynamic> electricLoadData = [
    {"icon": Icons.bolt, "label": "Potencia", "value": 0},
    {"icon": Icons.electric_bolt_rounded, "label": "Corriente", "value": 0},
    {"icon": Icons.power_rounded, "label": "Voltaje", "value": 0},
    {"icon": Icons.local_atm_outlined, "label": "Dinero", "value": 0},
    {"icon": Icons.access_time, "label": "TIempo", "value": 0},
    {
      "icon": Icons.battery_charging_full_rounded,
      "label": "Energía",
      "value": 0,
    },
  ];

  TextStyle get _keyTextStyle => TextStyle(
    fontFamily: 'Manrope',
    fontSize: (size.width * 0.06).clamp(22.0, 60.0).toDouble(),
    fontWeight: FontWeight.w600,
    color: const Color(0xFF285A48),
  );

  double get _keyIconSize => (size.width * 0.6).clamp(20.0, 35.0).toDouble();

  Widget _keyboardButton({required int index, required Widget child}) {
    const Color buttonColor = Color(0xFFEAF5EE);
    const Color borderColor = Color(0xFFB9D8C5);
    const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(60));

    return Material(
      color: Colors.transparent,
      borderRadius: buttonRadius,
      child: SizedBox.expand(
        child: InkWell(
          onTap: () => keyboardButtonPressed(index),
          borderRadius: buttonRadius,
          child: Ink(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: buttonRadius,
              border: Border.all(color: borderColor),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
  //Listas

  void keyboardButtonPressed(int index) {
    String value = index < 9
        ? '${index + 1}'
        : index == 10
        ? '0'
        : 'backspace';
    if (value == 'backspace') {
      if (controllerValue.text.isNotEmpty) {
        controllerValue.text = controllerValue.text.substring(
          0,
          controllerValue.text.length - 1,
        );
      }
    } else {
      if (controllerValue.text.length < 12) {
        controllerValue.text += value;
      }
    }
    notifyListeners();
  }

  Future<bool> createProgramming() async {
    _loading.show();
    try {
      await Future.delayed(const Duration(seconds: 5));
      return true;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
    return false;
  }

  @override
  void dispose() {
    controllerMainPageView.dispose();
    controllerSecondaryPageView.dispose();
    controllerValue.dispose();
    super.dispose();
  }
}

final pageProvider = ChangeNotifierProvider<PageProvider>(
  (ref) => PageProvider(
    ref: ref,
    size: MediaQuery.of(navigatorKey.currentContext!).size,
  ),
);
