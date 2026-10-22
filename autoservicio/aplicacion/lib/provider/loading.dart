import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void show() => state = true;

  void hide() => state = false;
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>(
  (ref) => LoadingNotifier(),
);
