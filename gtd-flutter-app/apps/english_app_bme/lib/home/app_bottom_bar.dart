import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/bottom_nav_bar_item.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

final List<BottomNavBarItem> tabs = [
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-course.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-course.svg", width: 24)),
    label: 'Courses',
    initialLocation: "/course",
  ),
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-mentor.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-mentor.svg", width: 24)),
    label: 'Mentor',
    initialLocation: '/mentor',
  ),
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-student.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-student.svg", width: 24)),
    label: 'Student',
    initialLocation: "/student",
  ),
];
