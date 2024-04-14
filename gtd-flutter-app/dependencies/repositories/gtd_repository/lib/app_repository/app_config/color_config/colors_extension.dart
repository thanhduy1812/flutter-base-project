import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/material.dart';
import 'package:gtd_repository/app_repository/app_config/gtd_app_config.dart';

extension GTDCustomColors on Colors {
  static const MaterialColor mainGreen =
      MaterialColor(0xFF1AA260, <int, Color>{50: Color(0xFFE6F5EC), 100: Color(0xFFBAE3CF), 500: Color(0xFF1AA260)});
  static const MaterialColor mainOrange =
      MaterialColor(0xFFF47920, <int, Color>{50: Color(0xFFFFF2E9), 100: Color(0xFFfac9a5), 500: Color(0xFFF47920)});
  static Tuple<Color, Color> gradientOrange = Tuple(item1: const Color(0xFFFE9B25), item2: const Color(0xFFFF5922));
  static Tuple<Color, Color> gradientBlue = Tuple(item1: const Color(0xFF007FFF), item2: const Color(0xFF134DD3));
  static Tuple<Color, Color> gradientGreen = Tuple(item1: const Color(0xFF1AA260), item2: const Color(0XFF05C49F));
  static const MaterialColor mainRed =
      MaterialColor(0xFFDB0D0D, <int, Color>{50: Color(0xFFFFEBEB), 500: Color(0xFFDB0D0D)});
  static const MaterialColor mainBlue =
      MaterialColor(0xFF0F5BDF, <int, Color>{50: Color(0xFFe7ecfa), 100: Color(0xFF99cbff), 500: Color(0xFF0F5BDF)});
  static const MaterialColor darkBlue =
      MaterialColor(0xFF0F5BDF, <int, Color>{50: Color(0xFFe7ecfa), 100: Color(0xFF99cbff), 500: Color(0xFF0158A9)});
  static const MaterialColor borderColor =
      MaterialColor(0xFFE5E7EB, <int, Color>{50: Color(0xFFE5E7EB), 500: Color(0xFFE5E7EB)});

  static const Color dividerColor = Color(0xFFF9FAFB);

  static MaterialColor mainAppColor({required GTDAppSupplier supplier, ThemeMode themeMode = ThemeMode.system}) {
    switch (supplier) {
      case GTDAppSupplier.b2c:
        return GTDCustomColors.mainGreen;
      case GTDAppSupplier.vib:
        return themeMode == ThemeMode.dark ? GTDCustomColors.mainBlue : GTDCustomColors.mainOrange;
      default:
        return GTDCustomColors.mainGreen;
    }
  }

  static Color lightMainAppColor({required GTDAppSupplier supplier, ThemeMode themeMode = ThemeMode.system}) {
    switch (supplier) {
      case GTDAppSupplier.b2c:
        return GTDCustomColors.mainGreen.shade50;
      case GTDAppSupplier.vib:
        return themeMode == ThemeMode.dark ? GTDCustomColors.mainBlue.shade50 : GTDCustomColors.mainOrange.shade50;
      default:
        return GTDCustomColors.mainGreen.shade50;
    }
  }

  static Color mediumMainAppColor({required GTDAppSupplier supplier, ThemeMode themeMode = ThemeMode.system}) {
    switch (supplier) {
      case GTDAppSupplier.b2c:
        return GTDCustomColors.mainGreen.shade100;
      case GTDAppSupplier.vib:
        return themeMode == ThemeMode.dark ? GTDCustomColors.mainBlue.shade100 : GTDCustomColors.mainOrange.shade100;
      default:
        return GTDCustomColors.mainGreen.shade100;
    }
  }

  static Color headerAppColor({required GTDAppSupplier supplier, ThemeMode themeMode = ThemeMode.system}) {
    switch (supplier) {
      case GTDAppSupplier.b2c:
        return GTDCustomColors.mainOrange;
      case GTDAppSupplier.vib:
        return themeMode == ThemeMode.dark ? GTDCustomColors.mainBlue : GTDCustomColors.mainOrange;
      default:
        return GTDCustomColors.mainOrange;
    }
  }

  static Color lightHeaderAppColor({required GTDAppSupplier supplier, ThemeMode themeMode = ThemeMode.system}) {
    switch (supplier) {
      case GTDAppSupplier.b2c:
        return GTDCustomColors.mainOrange.shade50;
      case GTDAppSupplier.vib:
        return themeMode == ThemeMode.dark ? GTDCustomColors.mainBlue.shade50 : GTDCustomColors.mainOrange.shade50;
      default:
        return GTDCustomColors.mainOrange.shade50;
    }
  }

  static Tuple<Color, Color> gradientColors(
      {required GTDAppSupplier supplier, ThemeMode themeMode = ThemeMode.system}) {
    switch (supplier) {
      case GTDAppSupplier.b2c:
        return GTDCustomColors.gradientGreen;
      case GTDAppSupplier.vib:
        return themeMode == ThemeMode.dark ? GTDCustomColors.gradientBlue : GTDCustomColors.gradientOrange;
      default:
        // return Tuple(item1: CustomColors.mainGreen, item2: CustomColors.mainGreen);
        return GTDCustomColors.gradientGreen;
    }
  }
}
