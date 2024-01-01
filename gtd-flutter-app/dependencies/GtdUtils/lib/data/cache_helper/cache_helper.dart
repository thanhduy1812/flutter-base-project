import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gtd_utils/data/cache_helper/models/gtd_cached_object.dart';
import 'package:gtd_utils/data/cache_helper/models/search_flight_info_hive.dart';
import 'package:gtd_utils/data/network/gtd_json_parser.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:path_provider/path_provider.dart' as path_provider;
enum CacheStorageType { flightBox, hotelBox, comboFlightBox, comboHotelBox, flightLocations, hotelLocations }

class CacheHelper {
  SharedPreferences? prefs;
  CacheHelper._();
  static final shared = CacheHelper._();
  // static Future<void> init() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  static const String cachedLang = "cachedLang";
  static const String cachedAppToken = "cachedAppToken";

  void initCachedMemory() async {
    try {
      prefs = await SharedPreferences.getInstance();
      cacheLanguage(GtdChannelSettingObject.shared.locale ?? "vi");
      cacheAppToken("Bearer ${GtdChannelSettingObject.shared.token}");
      print("Path initCachedMemory Stream success");
    } on PlatformException catch (e) {
      print("Path initCachedMemory PlatformException failed: $e");
    } catch (e) {
      print("Path initCachedMemory failed: $e");
    }
  }

  void initCachedStorage({String? directoryPath}) {
    String pathDirectoryHive = directoryPath ?? "";
    print("Path pathDirectoryHive: $pathDirectoryHive");
    if (directoryPath == null) {
      pathDirectoryHive = Directory.systemTemp.path;
      print("Path Temp: $pathDirectoryHive");
    }
    //Register Adapter Hive Objects
    Hive
      ..init(pathDirectoryHive)
      ..registerAdapter(SearchFlightInfoHiveAdapter());
  }

  String getCachedLanguage() {
    final code = prefs?.getString(cachedLang);
    if (code != null) {
      return code;
    } else {
      return 'vi';
    }
  }

  Future<void> cacheLanguage(String code) async {
    await prefs?.setString(cachedLang, code);
    print("Gotadi cacheLanguage: $code");
  }

  String getCachedAppToken() {
    if (prefs == null) {
      print("getCachedAppToken but prefs is null");
    }
    final token = prefs?.getString(cachedAppToken);
    return token ?? "";
    //Handle token null here
  }

  Future<void> cacheAppToken(String token) async {
    if (prefs == null) {
      print("cacheAppToken but prefs is null");
      initCachedMemory();
    }
    print("Gotadi cache Token precache: $token");
    try {
      // prefs ??= await SharedPreferences.getInstance();
      await prefs?.setString(cachedAppToken, token);
      print("Gotadi cache Token success: $token");
    } catch (e) {
      print("Gotadi cache Token error: $e");
    }
  }

  T? loadSavedObject<T>(T Function(Map<String, dynamic> map) fromJson, {required String key}) {
    final String? jsonString = prefs?.getString(key);
    if (jsonString != null) {
      T? model = JsonParser.jsonToModel(fromJson, json.decode(jsonString));
      return model;
    }
    return null;
  }

  Future<void> saveSharedObject(Map<String, dynamic> mapObject, {required String key}) async {
    await prefs?.setString(key, json.encode(mapObject));
  }

  List<T> loadListSavedObject<T>(T Function(Map<String, dynamic> map) fromJson, {required String key}) {
    final List<String>? jsonListString = prefs?.getStringList(key);
    if (jsonListString != null) {
      List<T> models = JsonParser.jsonArrayToModel(fromJson, jsonListString.map((e) => json.decode(e)).toList());
      return models;
    }
    return [];
  }

  Future<void> saveListSharedObject(List<Map<String, dynamic>> mapObjects, {required String key}) async {
    await prefs?.setStringList(key, mapObjects.map((e) => json.encode(e)).toList());
  }

  void removeCachedSharedObject(String key) async {
    await prefs?.remove(key);
  }

  static Future<void> cacheObject<T extends GtdCachedObject>(T object,
      {required CacheStorageType cacheStorageType}) async {
    var box = await Hive.openBox(cacheStorageType.name);
    box.put(T.toString(), object);
  }

  static void updateCache<T extends HiveObject>() {}

  static Future<T?> getCachedObject<T extends GtdCachedObject>({required CacheStorageType cacheStorageType}) async {
    var box = await Hive.openBox(cacheStorageType.name);
    T? result = box.get(T.toString(), defaultValue: null);
    return result;
  }

  static Future<void> closeCachedBox<T extends HiveObject>({required CacheStorageType cacheStorageType}) async {
    var box = await Hive.openBox(cacheStorageType.name);
    box.deleteFromDisk();
  }

  static Future<void> deleteKeyCached<T extends HiveObject>({required CacheStorageType cacheStorageType}) async {
    var box = await Hive.openBox(cacheStorageType.name);
    box.delete(T.toString());
  }

  static Future<void> deleteCachedAtIndex<T extends HiveObject>(int index,
      {required CacheStorageType cacheStorageType}) async {
    var box = await Hive.openBox(cacheStorageType.name);
    box.deleteAt(index);
  }
}
