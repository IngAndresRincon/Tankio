import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadingSequence();
  }

  void _loadingSequence() {
    Timer(const Duration(seconds: 5), () async {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login_biometric');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            Image.asset('assets/logo-tankio.png', width: 300),
            const SizedBox(height: 200),
            SizedBox(
              width: size.width * 0.2,
              child: LoadingAnimationWidget.dotsTriangle(
                color: const Color(0xFF60AF47),
                size: 80,
              ),
            ),
            Text(
              'Loading...',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
