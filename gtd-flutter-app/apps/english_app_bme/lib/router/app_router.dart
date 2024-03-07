import 'package:english_app_bme/home/view_controller/home_page.dart';
import 'package:english_app_bme/home/view_model/home_page_viewmodel.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_detail_page.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_page.dart';
import 'package:english_app_bme/lesson/view_model/lesson_detail_page_viewmodel.dart';
import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:english_app_bme/login/view_controller/login_page.dart';
import 'package:english_app_bme/login/view_model/login_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/router/app_router.dart';

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
    path: LoginPage.route,
    builder: (context, state) => LoginPage(
      viewModel: LoginPageViewModel(),
    ),
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: HomePage.route,
    builder: (context, state) => HomePage(
      viewModel: HomePageViewModel(),
    ),
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: LessonPage.route,
    builder: (context, state) {
      var viewModel = state.extra as LessonPageViewModel?;
      return LessonPage(
        viewModel: viewModel ?? LessonPageViewModel(),
      );
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: LessonDetailPage.route,
    builder: (context, state) {
      var viewModel = state.extra as LessonDetailPageViewModel?;
      return LessonDetailPage(
        viewModel: viewModel ?? LessonDetailPageViewModel(),
      );
    },
  ),
];
// final b2cBaseRouters = [...homeRouters];
// final b2b2cShellRouters = [...homeShellRouter, ...bookingWithRootKeyRouters];
final appRouter = AppRouter(
  initialLocation: LoginPage.route,
  routers: homeRouters,
  rootNavigatorKey: _rootNavigatorKey,
).generateRouter();
