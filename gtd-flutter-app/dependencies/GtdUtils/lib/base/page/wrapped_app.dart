import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/settings/setting_cupid.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/utils/app_bloc_observer/app_bloc_observer.dart';

class WrappedApp {
  WrappedApp._();

  static final shared = WrappedApp._();

  Widget createWrappedApp(String language, GoRouter appRouter, String appTitle,
      {GtdAppScheme appScheme = GtdAppScheme.uatvib, ThemeMode? themeMode}) {
    Bloc.observer = AppBlocObserver();

    /// Set app scheme
    AppConst.shared.appScheme = appScheme;
    AppConst.shared.themeMode = themeMode ?? ThemeMode.light;

    return GtdBaseApp(
      router: appRouter,
      title: appTitle,
    );
  }
}

class GtdBaseApp extends StatelessWidget {
  const GtdBaseApp({super.key, required this.router, required this.title});
  final GoRouter router;
  final String title;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SettingCubit()),
        ],
        child: BlocBuilder<SettingCubit, ThemeData>(builder: (context, state) {
          return MaterialApp.router(
              // routerConfig: router,
              routeInformationParser: router.routeInformationParser,
              routeInformationProvider: router.routeInformationProvider,
              routerDelegate: router.routerDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
              debugShowCheckedModeBanner: true,
              title: title,
              themeMode: AppConst.shared.themeMode,
              theme: AppConst.shared.appScheme.appSupplier.appTheme.lightTheme,
              darkTheme: AppConst.shared.appScheme.appSupplier.appTheme.darkTheme,
              builder: EasyLoading.init());
        }));
  }
}
