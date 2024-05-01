import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/common_color/common_color.dart';
import 'router/router_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      darkTheme: darkmode,
      themeMode: ThemeMode.dark,
    );
  }
}

ThemeData darkmode = ThemeData(
  primaryColor: secondrycolor,
  scaffoldBackgroundColor: secondrycolor,
  useMaterial3: true,
);
