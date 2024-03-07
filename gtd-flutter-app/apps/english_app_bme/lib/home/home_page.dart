import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/network/gtd_app_logger.dart';

class HomePage extends BaseStatelessPage<BasePageViewModel> {
  static const String route = '/home';
  const HomePage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return const SizedBox();
  }

  @override
  Widget? buildBottomBar(BuildContext pageContext) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) {
          Logger.i("index");
        },
        items: tabs);
  }
}
