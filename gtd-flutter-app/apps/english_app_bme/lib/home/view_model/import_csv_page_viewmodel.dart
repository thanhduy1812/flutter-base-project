import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';

class ImportCSVPageViewModel extends BasePageViewModel {
  List<BmeOriginCourse> courses = [];
  ImportCSVPageViewModel(this.courses) {
    title = "Data Sheet";
  }
}