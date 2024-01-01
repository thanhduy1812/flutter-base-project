import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppConfig {
  String env;
  String locale;
  AppConfig(this.env, this.locale);
}

class GTDAppCustomDelegate {
  static const platform = MethodChannel('com.gotadi.dev/config');
  AppConfig? appConfig;

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform
          .invokeMethod('getBatteryLevel', {"bookingNumber": "abc1235"});
    } on PlatformException {
      debugPrint("gotadi error platform");
    } on MissingPluginException {
      debugPrint("gotadi error platform");
    }
  }

  void getLocale() async {
    try {
      final int result = await platform
          .invokeMethod('getLocale', {"bookingNumber": "abc1235"});
    } on PlatformException {
      debugPrint("gotadi error platform");
    } on MissingPluginException {
      debugPrint("gotadi error platform");
    }
  }

  void getAppConfig() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == "getAppConfig") {
        if (kDebugMode) {
          print(call);
        }
      }
    });
  }
}
