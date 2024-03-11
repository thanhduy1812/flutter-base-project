import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/lesson_roadmap_rs.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';

class LessonDetailPageViewModel extends BasePageViewModel {
  final BmeOriginCourse course;
  final LessonRoadmapRs lessonRoadmapRs;
  List<BmeUser> bmeUsers = [];
  String role = "";
  LessonDetailPageViewModel({required this.course, required this.lessonRoadmapRs}) {
    var bmeUser = CacheHelper.shared.loadSavedObject(BmeUser.fromJson, key: CacheStorageType.accountBox.name);
    role = bmeUser?.role ?? "USER";
    title = lessonRoadmapRs.lessonName ?? "";
  }
}
