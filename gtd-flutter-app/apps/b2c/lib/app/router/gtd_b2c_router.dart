import 'package:gtd_booking/modules/my_booking/view_controller/gtd_my_booking_page.dart';
import 'package:gtd_booking/modules/my_booking/view_controller/vib_my_booking_page.dart';
import 'package:gtd_booking/modules/my_booking/view_model/gtd_my_booking_page_viewmodel.dart';
import 'package:new_gotadi/app/home/views/home_page.dart';
import 'package:new_gotadi/app/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/router/booking_search_router.dart';
import 'package:gtd_utils/base/page/bottom_tabbar_navigation.dart';
import 'package:gtd_utils/base/router/app_router.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';

import 'gtd_b2c_list_nav_item.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final List<RouteBase> homeRouter = [
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: '/',
    name: 'home', //Used for pushNamed and pass params
    builder: (context, state) => MainPage(
      key: state.pageKey,
    ),
    redirect: (context, state) {
      return "/";
    },
    // routes: bookingRouters,
  ),
];

final List<RouteBase> homeShellRouter = [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    pageBuilder: (context, state, child) {
      print(state.matchedLocation);
      return NoTransitionPage(
        // child: MainPage(),
        child: BottomTabbarNavigation(
          location: state.matchedLocation,
          tabs: tabs,
          child: child,
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/',
        parentNavigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: HomePage(),
          );
        },
      ),
      GoRoute(
        path: '/myHomebooking',
        parentNavigatorKey: _shellNavigatorKey,
        builder: (context, state) {
          switch (AppConst.shared.appScheme.appSupplier) {
            case GtdAppSupplier.b2c:
              return VibMyBookingPage(key: state.pageKey);
            default:
              return GtdMyBookingPage(key: state.pageKey, viewModel: GtdMyBookingPageViewModel(),);
          }
        },
      ),
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: '/promotions',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: Scaffold(
              body: Center(child: Text("Promotions")),
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: '/account',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: Scaffold(
              body: Center(child: Text("Account")),
            ),
            //TODO: Implement AccountPage with Bloc
            // child: AccountPage(),
          );
        },
      ),
    ],
  ),
];
final bookingWithRootKeyRouters =
    GtdBookingRouter.bookingBaseRouters(rootKey: _rootNavigatorKey, shellKey: _shellNavigatorKey);
final b2cBaseRouters = [...homeShellRouter, ...bookingWithRootKeyRouters];
// final b2b2cShellRouters = [...homeShellRouter, ...bookingWithRootKeyRouters];
final appRouter =
    AppRouter(initialLocation: "/", routers: b2cBaseRouters, rootNavigatorKey: _rootNavigatorKey).generateRouter();
