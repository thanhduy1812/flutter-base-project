import 'package:flutter/material.dart';

import 'gtd_app_theme.dart';

enum GtdAppScheme {
  uatvib('env.uat', GTDAppSupplier.vib, GtdPackageResoure.vib, false),
  prodvib('env.prod', GTDAppSupplier.vib, GtdPackageResoure.vib, false),
  prodB2C('env.prod', GTDAppSupplier.b2c, GtdPackageResoure.gotadiB2C, true),
  uatB2C('env.uat', GTDAppSupplier.b2c, GtdPackageResoure.gotadiB2C, true),
  prodB2B('env.prod', GTDAppSupplier.agent, GtdPackageResoure.gotadiB2B, true),
  uatB2B('env.uat', GTDAppSupplier.agent, GtdPackageResoure.gotadiB2B, true);

  final String envFile;
  final GTDAppSupplier appSupplier;
  final GtdPackageResoure packageResoure;
  final bool hasPayment;
  const GtdAppScheme(this.envFile, this.appSupplier, this.packageResoure, this.hasPayment);

  static GtdAppScheme getAppScheme(String env, String partner) {
    switch (partner) {
      case "vib":
        return (env == "prod") ? GtdAppScheme.prodvib : GtdAppScheme.uatvib;
      case "b2c":
        return (env == "prod") ? GtdAppScheme.prodB2C : GtdAppScheme.uatB2C;
      default:
        return (env == "prod") ? GtdAppScheme.prodB2C : GtdAppScheme.uatB2C;
    }
  }
}

enum GTDAppSupplier {
  b2c(GtdAppTheme.gotadiB2C),
  agent(GtdAppTheme.gotadiAgent),
  ca(GtdAppTheme.gotadiAgent),
  vib(GtdAppTheme.vib);

  final GtdAppTheme appTheme;
  const GTDAppSupplier(this.appTheme);
}

enum GtdAppTheme {
  gotadiB2C,
  gotadiAgent,
  vib;

  const GtdAppTheme();
}

extension GtdAppThemeData on GtdAppTheme {
  ThemeData get lightTheme {
    switch (this) {
      case GtdAppTheme.gotadiB2C:
        return GtdThemeData.gotadiB2CLightTheme;
      case GtdAppTheme.gotadiAgent:
        return GtdThemeData.gotadiB2CLightTheme;
      case GtdAppTheme.vib:
        return GtdThemeData.vibLightTheme;
      default:
        return GtdThemeData.vibLightTheme;
    }
  }

  ThemeData get darkTheme {
    switch (this) {
      case GtdAppTheme.gotadiB2C:
        return GtdThemeData.gotadiB2CLightTheme;
      case GtdAppTheme.gotadiAgent:
        return GtdThemeData.gotadiB2CLightTheme;
      case GtdAppTheme.vib:
        return GtdThemeData.vibdarkTheme;
      default:
        return GtdThemeData.vibdarkTheme;
    }
  }
}

// Define Resource Asset Package Name here
enum GtdPackageResoure {
  common('common_resource'),
  gotadiB2C('gotadi_resource'),
  gotadiB2B('gotadi_resource'),
  vib('vib_resource');

  final String resource;
  const GtdPackageResoure(this.resource);
}
