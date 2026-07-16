import 'package:flutter/widgets.dart';

class NavItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<int> rolList;

  const NavItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.rolList,
  });
}
