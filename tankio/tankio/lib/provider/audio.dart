// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider extends ChangeNotifier {
  Ref ref;
  final player = AudioPlayer();
  AudioProvider({required this.ref});

  void playAudio() async {
    await player.play(AssetSource("universfield-new-notification.mp3"));
  }
}

final audioControllerProvider = ChangeNotifierProvider<AudioProvider>(
  (ref) => AudioProvider(ref: ref),
);
