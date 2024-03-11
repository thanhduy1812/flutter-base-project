import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/lesson_roadmap_rs.dart';

class LessonDetailPageViewModel extends BasePageViewModel {
  final BmeOriginCourse course;
  final LessonRoadmapRs lessonRoadmapRs;
  List<BmeUser> bmeUsers = [];
  LessonDetailPageViewModel({required this.course, required this.lessonRoadmapRs}) {
    title = lessonRoadmapRs.lessonName ?? "";
  }
}
