import 'package:cctv_stream_app/domain/home/homescreen.dart';
import 'package:cctv_stream_app/domain/splash/splash_page.dart';
import 'package:cctv_stream_app/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: Routes.homescreen.path,
    name: Routes.homescreen.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: HomeScreen());
    },
  ),
    GoRoute(
    path: Routes.splashScreen.path,
    name: Routes.splashScreen.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: SplashScreen());
    },
  ),
  // GoRoute(
  //   path: Routes.discoverscreen.path,
  //   name: Routes.discoverscreen.name,
  //   pageBuilder: (context, state) {
  //     return CupertinoPage(
  //         child: DiscoverScreen(model_list: state.extra as List<PlaceModel>,));
  //   },
  // ),
  // GoRoute(
  //   path: Routes.checkoutscreen.path,
  //   name: Routes.checkoutscreen.name,
  //   pageBuilder: (context, state) {
  //     return  CupertinoPage(child: CheckOutScreen(model: state.extra as PlaceModel,));
  //   },
  // ),
]);
