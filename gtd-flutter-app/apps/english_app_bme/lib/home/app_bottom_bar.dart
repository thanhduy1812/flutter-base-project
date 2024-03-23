import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/bottom_nav_bar_item.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

final List<BottomNavBarItem> tabs = [
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-course.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-course.svg", width: 24)),
    label: 'Courses',
    initialLocation: "/course",
  ),
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-mentor.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-mentor.svg", width: 24)),
    label: 'Teachers',
    initialLocation: '/mentor',
  ),
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-student.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn),
        child: GtdImage.svgFromAsset(assetPath: "assets/image/bottom-student.svg", width: 24)),
    label: 'Student',
    initialLocation: "/student",
  ),
  const BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: Icon(Icons.account_circle_rounded, size: 24)),
    activeIcon: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn),
        child: Icon(Icons.account_circle_rounded, size: 24)),
    label: 'Account',
    initialLocation: "/account",
  ),
];

const appBlueDeepColor = Color(0xFF005248);
const appBlueLightColor = Color(0xFFCCDCDA);
// const appBlueDeepColor = Colors.blueAccent;
// final appBlueLightColor = Colors.blue.shade50;
const appOrangeLightColor = Color(0xFFFFB057);
const appOrangeDarkColor = Color(0xFFFFB057);
