import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/my_booking/view_controller/gtd_my_booking_page.dart';
import 'package:gtd_booking/modules/my_booking/view_model/gtd_my_booking_page_viewmodel.dart';
import 'package:new_gotadi/app/account/account_main/account_main.dart';
import 'package:new_gotadi/app/home/view_controller/home_page.dart';
import 'package:new_gotadi/app/home/view_model/home_page_viewmodel.dart';
import 'package:new_gotadi/app/promotions/view_controller/promotion_page.dart';
import 'package:new_gotadi/app/promotions/view_model/promotion_page_view_model.dart';
import 'package:new_gotadi/app/router/gtd_b2c_list_nav_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String route = '/mainPage';

  @override
  MainPageState createState() => MainPageState();
}

final _navigatorKey = GlobalKey();
final _navigatorKeySetting = GlobalKey();

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    HomePage(viewModel: HomePageViewModel()),
    GtdMyBookingPage(viewModel: GtdMyBookingPageViewModel()),
    PromotionPage(viewModel: PromotionPageViewModel()),
    AccountPage(viewModel: AccountPageViewModel())
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
      body: _widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (i) => setState(() {
          selectedIndex = i;
        }),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: tabs,
      ),
    );
  }
}
