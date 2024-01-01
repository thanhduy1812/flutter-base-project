import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/bottom_nav_bar_item.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';

final List<BottomNavBarItem> tabs = [
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "home.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "home.svg", width: 24)),
    label: 'Home',
    initialLocation: '/',
  ),
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "list-booking.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "list-booking.svg", width: 24)),
    label: 'My Booking',
    initialLocation: '/myHomebooking',
  ),
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "promotion.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "promotion.svg", width: 24)),
    label: 'Promotions',
    initialLocation: '/promotions',
  ),
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "account.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "account.svg", width: 24)),
    label: 'Account',
    initialLocation: '/account',
  ),
];
