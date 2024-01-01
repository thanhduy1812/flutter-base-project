import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gtd_utils/base/bloc/local_state.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/helpers/extension/string_extension.dart';
import 'package:hive/hive.dart';

class LocalCubit extends Cubit<LocalState> {
  LocalCubit() : super(LocalInitState());

  void getSavedLanguage() {
    final cachedLanguageCode = CacheHelper.shared.getCachedLanguage();
    emit(LocalLanguageState(locale: Locale(cachedLanguageCode)));
  }

  Future<void> changeLanguage(String lang) async {
    await CacheHelper.shared.cacheLanguage(lang);
    emit(LocalLanguageState(locale: Locale(lang)));
  }

  void initCached() async {
    CacheHelper.shared.initCachedStorage();
    CacheHelper.shared.initCachedMemory();
  }

  void initSetting({String? lang}) async {
    //TODO: Read env from env file
    // String env = "vib";
    GtdAppScheme appScheme = AppConst.shared.appScheme;
    String pathForAssetEnv = GtdString.pathForAsset(AppConst.shared.commonResource, 'assets/env/${appScheme.envFile}');
    await dotenv.load(fileName: pathForAssetEnv);
    if (lang != null) {
      await CacheHelper.shared.cacheLanguage(lang);
    }
    String cachedLanguageCode = CacheHelper.shared.getCachedLanguage();
    Locale cachedLocale = (lang != null) ? Locale(lang) : Locale(cachedLanguageCode);

    // String packageResource = (env == "vib") ? AppConst.packageVIB : AppConst.packageB2B;

    LocalSettingState settingState =
        LocalSettingState(locale: cachedLocale, packageResource: appScheme.packageResoure.resource);
    emit(settingState);
  }

  @override
  Future<void> close() {
    Hive.close();
    return super.close();
  }
}
