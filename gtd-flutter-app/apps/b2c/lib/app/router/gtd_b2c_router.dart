import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/my_booking/view_controller/gtd_my_booking_page.dart';
import 'package:gtd_booking/modules/my_booking/view_model/gtd_my_booking_page_viewmodel.dart';
import 'package:gtd_booking/modules/router/booking_search_router.dart';
import 'package:gtd_utils/base/page/bottom_tabbar_navigation.dart';
import 'package:gtd_utils/base/router/app_router.dart';
import 'package:new_gotadi/app/account/account_edit/account_edit.dart';
import 'package:new_gotadi/app/account/change_password/change_password.dart';
import 'package:new_gotadi/app/account/log_in/log_in.dart';
import 'package:new_gotadi/app/account/register/register.dart';
import 'package:new_gotadi/app/account/settings/settings.dart';
import 'package:new_gotadi/app/home/view_controller/home_page.dart';
import 'package:new_gotadi/app/home/view_model/home_page_viewmodel.dart';
import 'package:new_gotadi/app/main/main_page.dart';
import 'package:new_gotadi/app/main/splash_page.dart';
import 'package:new_gotadi/app/membership/view_controller/membership_page.dart';
import 'package:new_gotadi/app/membership/view_model/membership_page_viewmodel.dart';
import 'package:new_gotadi/app/notifications/view_controller/notifications_page.dart';
import 'package:new_gotadi/app/notifications/view_model/notifications_page_view_model.dart';
import 'package:new_gotadi/app/promotions/view_controller/promotion_page.dart';
import 'package:new_gotadi/app/promotions/view_model/promotion_page_view_model.dart';

import '../account/account_main/account_main.dart';
// import 'gtd_b2c_list_nav_item.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
BuildContext? get rootContext => _rootNavigatorKey.currentState?.context;

final List<RouteBase> homeShellRouter = [
  //MARK: Only use for puporse rebuild page when change tab
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) => const MainPage(),
    // pageBuilder: (context, state, child) {
    //   print(state.matchedLocation);
    //   return  NoTransitionPage(
    //     // child: MainPage(),
    //     child: BottomTabbarNavigation(
    //       location: state.matchedLocation,
    //       tabs: tabs,
    //       child: child,
    //     ),
    //   );
    // },
    routes: [
      GoRoute(
        path: HomePage.route,
        name: "home",
        parentNavigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: HomePage(
              key: state.pageKey,
              viewModel: HomePageViewModel(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/myHomebooking',
        parentNavigatorKey: _shellNavigatorKey,
        // builder: (context, state) {
        //   return GtdMyBookingPage(
        //     key: state.pageKey,
        //     viewModel: GtdMyBookingPageViewModel(),
        //   );
        // },
        pageBuilder: (context, state) => NoTransitionPage(
            child: GtdMyBookingPage(
          key: state.pageKey,
          viewModel: GtdMyBookingPageViewModel(),
        )),
      ),
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: PromotionPage.route,
        // builder: (context, state) => PromotionPage(viewModel: PromotionPageViewModel()),
        pageBuilder: (context, state) {
          return NoTransitionPage(key: state.pageKey, child: PromotionPage(viewModel: PromotionPageViewModel())
              // child: Scaffold(
              //   body: Center(child: Text("Promotions")),
              // ),
              );
        },
      ),
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: '/account',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: AccountPage(
              viewModel: AccountPageViewModel(),
            ),
          );
        },
      ),
    ],
  ),
];
final bookingWithRootKeyRouters = GtdBookingRouter.bookingBaseRouters(
  rootKey: _rootNavigatorKey,
  shellKey: _shellNavigatorKey,
);
final List<RouteBase> authenticationRouters = [
  GoRoute(
    path: LogInPage.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return LogInPage(
        key: state.pageKey,
        viewModel: LogInPageViewModel(),
      );
    },
  ),
  GoRoute(
    path: RegisterPage.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return RegisterPage(
        key: state.pageKey,
        viewModel: RegisterPageViewModel(),
      );
    },
  ),
  GoRoute(
    path: SettingsPage.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return SettingsPage(
        key: state.pageKey,
        viewModel: SettingsPageViewModel(),
      );
    },
  ),
  GoRoute(
    path: AccountEditPage.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return AccountEditPage(
        key: state.pageKey,
        viewModel: AccountEditPageViewModel(),
      );
    },
  ),
  GoRoute(
    path: ChangePasswordPage.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return ChangePasswordPage(
        key: state.pageKey,
        viewModel: ChangePasswordPageViewModel(),
      );
    },
  ),
];

final List<RouteBase> b2cChildRouters = [
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: NotificationsPage.route,
    builder: (context, state) => NotificationsPage(viewModel: NotificationsPageViewModel()),
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: MembershipPage.route,
    builder: (context, state) => MembershipPage(viewModel: MembershipPageViewModel()),
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: SplashScreen.route,
    builder: (context, state) => const SplashScreen(),
  ),
];
final b2cBaseRouters = [
  ...authenticationRouters,
  ...b2cChildRouters,
  ...homeShellRouter,
  ...bookingWithRootKeyRouters,
];
// final b2b2cShellRouters = [...homeShellRouter, ...bookingWithRootKeyRouters];
final appRouter = AppRouter(
  initialLocation: SplashScreen.route,
  routers: b2cBaseRouters,
  rootNavigatorKey: _rootNavigatorKey,
).generateRouter();
