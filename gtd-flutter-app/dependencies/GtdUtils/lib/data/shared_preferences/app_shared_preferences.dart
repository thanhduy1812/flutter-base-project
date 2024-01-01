import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static SharedPreferences? _prefs;

  /// Static func for safe-null check
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static putInteger(String key, int value) {
    if (_prefs != null) _prefs!.setInt(key, value);
  }

  static int getInteger(String key) {
    return _prefs == null ? 0 : _prefs!.getInt(key) ?? 0;
  }

  static putString(String key, String value) {
    if (_prefs != null) _prefs!.setString(key, value);
  }

  static String getString(String key) {
    return _prefs == null ? 'DEFAULT_VALUE' : _prefs!.getString(key) ?? "";
  }

  static putBool(String key, bool value) {
    if (_prefs != null) _prefs!.setBool(key, value);
  }

  static bool getBool(String key) {
    return _prefs == null ? false : _prefs!.getBool(key) ?? false;
  }

  ///Func for using in apps
  void saveToken(String token) {
    putString('appToken', token);
  }

  String getAppToken() {
    return getString('appToken');
  }
}
