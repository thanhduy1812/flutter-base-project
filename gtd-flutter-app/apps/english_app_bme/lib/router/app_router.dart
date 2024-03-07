import 'package:english_app_bme/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/router/app_router.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';

import '../splash/splash_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
BuildContext? get rootContext => _rootNavigatorKey.currentState?.context;

final List<RouteBase> homeRouters = [
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: SplashScreen.route,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: HomePage.route,
    builder: (context, state) => HomePage(
      viewModel: BasePageViewModel(
        title: "Course",
      ),
    ),
  ),
];
// final b2cBaseRouters = [...homeRouters];
// final b2b2cShellRouters = [...homeShellRouter, ...bookingWithRootKeyRouters];
final appRouter = AppRouter(
  initialLocation: SplashScreen.route,
  routers: homeRouters,
  rootNavigatorKey: _rootNavigatorKey,
).generateRouter();
