import 'dart:async';

import 'package:gtd_utils/base/view_model/base_page_view_model.dart';

enum HomePageTab {
  course(0, "Courses"),
  mentor(1, "Mentors"),
  student(2, "Students");

  final int tabValue;
  final String title;
  const HomePageTab(this.tabValue, this.title);
}

class HomePageViewModel extends BasePageViewModel {
  HomePageTab seletedTab = HomePageTab.course;
  StreamController<String> querySearchController = StreamController();
  HomePageViewModel() {
    title = seletedTab.title;
  }

  void selectTab(int value) {
    HomePageTab tab =
        HomePageTab.values.firstWhere((element) => element.tabValue == value, orElse: () => HomePageTab.course);
    seletedTab = tab;
    title = seletedTab.title;
    notifyListeners();
  }
}
