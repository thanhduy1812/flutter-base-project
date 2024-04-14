import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/material.dart';
import 'package:gtd_repository/app_repository/app_config/app_const.dart';
import 'package:gtd_repository/app_repository/app_config/gtd_app_config.dart';

import 'colors_extension.dart';

class GTDAppColors {
  static MaterialColor get mainColor {
    ThemeMode? themMode = GTDAppConst.shared.themeMode;
    GTDAppSupplier supplier = GTDAppConst.shared.appScheme.appSupplier;
    return GTDCustomColors.mainAppColor(supplier: supplier, themeMode: themMode ?? ThemeMode.system);
  }

  static Color get lightMainColor {
    ThemeMode? themMode = GTDAppConst.shared.themeMode;
    GTDAppSupplier supplier = GTDAppConst.shared.appScheme.appSupplier;
    return GTDCustomColors.lightMainAppColor(supplier: supplier, themeMode: themMode ?? ThemeMode.system);
  }

  static Color get mediumMainColor {
    ThemeMode? themMode = GTDAppConst.shared.themeMode;
    GTDAppSupplier supplier = GTDAppConst.shared.appScheme.appSupplier;
    return GTDCustomColors.mediumMainAppColor(supplier: supplier, themeMode: themMode ?? ThemeMode.system);
  }

  static Color get errorColor {
    return GTDCustomColors.mainRed;
  }

  static Color get boldText {
    return Colors.grey.shade900;
  }

  static Color get normalText {
    return Colors.grey.shade900;
  }

  static Color get subText {
    return Colors.grey.shade600;
  }

  static Color get strikeText {
    return Colors.grey.shade500;
  }

  static Color get currencyText {
    return GTDCustomColors.mainOrange;
  }

  static Color get buttonColor {
    ThemeMode? themMode = GTDAppConst.shared.themeMode;
    GTDAppSupplier supplier = GTDAppConst.shared.appScheme.appSupplier;
    return GTDCustomColors.mainAppColor(supplier: supplier, themeMode: themMode ?? ThemeMode.system);
  }

  static LinearGradient get appGradient {
    ThemeMode? themMode = GTDAppConst.shared.themeMode;
    GTDAppSupplier supplier = GTDAppConst.shared.appScheme.appSupplier;
    Tuple<Color, Color> tuple =
        GTDCustomColors.gradientColors(supplier: supplier, themeMode: themMode ?? ThemeMode.system);
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.1, 1],
      colors: [tuple.item1, tuple.item2],
    );
  }

  static LinearGradient get boxGreyGradient {
    Tuple<Color, Color> tuple = Tuple(item1: Colors.grey.shade200, item2: Colors.white);
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.1, 1],
      colors: [tuple.item1, tuple.item2],
    );
  }
}
