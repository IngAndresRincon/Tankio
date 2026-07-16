import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProvider extends ChangeNotifier {
  Ref ref;

  HomeProvider({required this.ref});

  int indexPage = 0;
  final controllerPage = PageController(initialPage: 0);
}

final homeProvider = ChangeNotifierProvider<HomeProvider>(
  (ref) => HomeProvider(ref: ref),
);
