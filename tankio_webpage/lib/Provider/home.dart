import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProvider extends ChangeNotifier {
  final Ref ref;
  HomeProvider({required this.ref});
}

final homeProvider = ChangeNotifierProvider<HomeProvider>(
  (ref) => HomeProvider(ref: ref),
);
