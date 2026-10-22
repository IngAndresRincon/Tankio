import 'package:aplicacion/page/index/home_page.dart';
import 'package:aplicacion/page/index/index_page.dart';
import 'package:aplicacion/provider/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexScreen extends ConsumerStatefulWidget {
  const IndexScreen({super.key});

  @override
  ConsumerState<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends ConsumerState<IndexScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(pageProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF08141F),
      body: PageView(
        controller: page.controllerMainPageView,
        physics: const NeverScrollableScrollPhysics(),
        children: [IndexPage(), HomePage()],
      ),
    );
  }
}
