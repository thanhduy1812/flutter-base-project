import 'package:flutter/material.dart';

class BottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const BottomNavBarItem({required this.initialLocation, required super.icon, super.label, Widget? activeIcon})
      : super(activeIcon: activeIcon ?? icon);
}
