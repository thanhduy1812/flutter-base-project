import 'package:flutter/material.dart';
import 'package:gtd_utils/constants/app_const.dart';

class BookingConst {
  BookingConst._();
  static final shared = BookingConst._();

  String assetIconTheme(BuildContext context) {
    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isDarkMode = AppConst.shared.themeMode == ThemeMode.dark;
    if (isDarkMode) {
      return "assets/icons-dark/";
    } else {
      return "assets/icons/";
    }
  }
}
