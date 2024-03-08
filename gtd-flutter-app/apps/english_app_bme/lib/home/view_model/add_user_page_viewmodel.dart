import 'package:english_app_bme/home/view_model/home_page_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';

class AddUserPageViewModel extends BasePageViewModel {
  final HomePageTab homePageTab;
  late final String headerTitle;
  AddUserPageViewModel({this.homePageTab = HomePageTab.mentor}) {
    switch (homePageTab) {
      case HomePageTab.mentor:
        // title = "Mentor";
        headerTitle = "Add a mentor";
        break;
      case HomePageTab.student:
        // title = "Student";
        headerTitle = "Add a student";
        break;
      default:
        headerTitle = "";
    }
  }
}
