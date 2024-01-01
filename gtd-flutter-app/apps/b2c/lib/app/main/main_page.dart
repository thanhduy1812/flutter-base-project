import 'package:new_gotadi/app/home/views/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String route = '/navScreen';

  @override
  MainPageState createState() => MainPageState();
}

final _navigatorKey = GlobalKey();
final _navigatorKeySetting = GlobalKey();

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int selectedIndex = 0;
  final _screens = [
    Navigator(
      key: _navigatorKey,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => const HomePage(),
      ),
    ),
    const Scaffold(body: Center(child: Text('Explore'))),
    const Scaffold(body: Center(child: Text('Add'))),
    // Navigator(
    //   key: _navigatorKeySetting,
    //   onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
    //     settings: settings,
    //     builder: (BuildContext context) => const AccountPage(),
    //   ),
    // ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: _screens
              .asMap()
              .map((i, screen) => MapEntry(
                    i,
                    Offstage(
                      offstage: selectedIndex != i,
                      child: screen,
                    ),
                  ))
              .values
              .toList()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (i) => setState(() => selectedIndex = i),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: [
          BottomNavigationBarItem(
              icon: GtdAppIcon.iconNamedSupplier(iconName: "home.svg", width: 24),
              activeIcon: GtdAppIcon.iconNamedSupplier(iconName: "home.svg", width: 24),
              label: 'global.homepage'.tr()),
          BottomNavigationBarItem(
              icon: GtdAppIcon.iconNamedSupplier(iconName: "list-booking.svg", width: 24),
              activeIcon: GtdAppIcon.iconNamedSupplier(iconName: "list-booking.svg", width: 24),
              label: 'global.myBooking'.tr()),
          BottomNavigationBarItem(
            icon: GtdAppIcon.iconNamedSupplier(iconName: "promotion.svg", width: 24),
            activeIcon: GtdAppIcon.iconNamedSupplier(iconName: "promotion.svg", width: 24),
            label: 'global.promotions'.tr(),
          ),
          BottomNavigationBarItem(
            icon: GtdAppIcon.iconNamedSupplier(iconName: "account.svg", width: 24),
            activeIcon: GtdAppIcon.iconNamedSupplier(iconName: "account.svg", width: 24),
            label: 'global.account'.tr(),
          ),
        ],
      ),
    );
  }
}
