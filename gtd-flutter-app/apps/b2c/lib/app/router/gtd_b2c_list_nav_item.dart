import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/bottom_nav_bar_item.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:new_gotadi/app/home/view_controller/home_page.dart';
import 'package:new_gotadi/app/promotions/view_controller/promotion_page.dart';

final List<BottomNavBarItem> tabs = [
  BottomNavBarItem(
    icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "home.svg", width: 24)),
    activeIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        child: GtdAppIcon.iconNamedSupplier(iconName: "home.svg", width: 24)),
    label: 'Home',
    initialLocation: HomePage.route,
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
    initialLocation: PromotionPage.route,
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
