import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/router/booking_search_router.dart';
import 'package:gtd_utils/base/router/app_router.dart';

import 'main.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final List<RouteBase> homeRouter = [
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: '/',
    name: 'home', //Used for pushNamed and pass params
    builder: (context, state) => B2B2CWidget(
      key: state.pageKey,
    ),
    redirect: (context, state) {
      return "/";
    },
    // routes: bookingRouters,
  ),
];

// final List<RouteBase> homeShellRouter = [
//   ShellRoute(
//     navigatorKey: _shellNavigatorKey,
//     pageBuilder: (context, state, child) {
//       print(state.location);
//       return NoTransitionPage(
//         child: ScaffoldWithNavBar(
//           location: state.location,
//           child: child,
//         ),
//       );
//     },
//     routes: [
//       GoRoute(
//         path: '/',
//         parentNavigatorKey: _shellNavigatorKey,
//         pageBuilder: (context, state) {
//           return const NoTransitionPage(
//             child: B2B2CWidget(),
//           );
//         },
//       ),
//       GoRoute(
//         path: '/mybooking',
//         parentNavigatorKey: _shellNavigatorKey,
//         pageBuilder: (context, state) {
//           return const NoTransitionPage(
//             child: Scaffold(
//               body: Center(child: Text("My Booking")),
//             ),
//           );
//         },
//       ),
//       GoRoute(
//         parentNavigatorKey: _shellNavigatorKey,
//         path: '/promotions',
//         pageBuilder: (context, state) {
//           return const NoTransitionPage(
//             child: Scaffold(
//               body: Center(child: Text("Promotions")),
//             ),
//           );
//         },
//       ),
//     ],
//   ),
//   GoRoute(
//     parentNavigatorKey: _rootNavigatorKey,
//     path: '/account',
//     pageBuilder: (context, state) {
//       return NoTransitionPage(
//         child: Scaffold(
//           appBar: AppBar(),
//           body: const Center(child: Text("Account")),
//         ),
//       );
//     },
//   ),
// ];
final bookingWithRootKeyRouters =
    GtdBookingRouter.bookingBaseRouters(rootKey: _rootNavigatorKey);
final b2b2cBaseRouters = [...homeRouter, ...bookingWithRootKeyRouters];
// final b2b2cShellRouters = [...homeRouter, ...bookingWithRootKeyRouters];
final appRouter = AppRouter(
  initialLocation: "/homeVIB",
  routers: b2b2cBaseRouters,
  rootNavigatorKey: _rootNavigatorKey,
);
// final appRouter = AppRouter(
//   initialLocation: "/vib",
//   routers: bookingWithRootKeyRouters,
// );
// final appShellRouter = AppRouter(
//     initialLocation: "/vib",
//     routers: b2b2cShellRouters,
//     rootNavigatorKey: _rootNavigatorKey);
