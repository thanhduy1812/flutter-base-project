import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/lesson_roadmap_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';

enum LessonRating { sad, normal, happy }

class LessonPageViewModel extends BasePageViewModel {
  final BmeOriginCourse course;
  List<LessonRoadmapRs> lessonRoadmaps = [];
  LessonPageViewModel({required this.course}) {
    title = course.maLop ?? "--";
    loadLessonRoadmaps();
  }

  void loadLessonRoadmaps() async {
    await BmeRepository.shared.findLessonRoadmapByKey(course.maLop!).then((value) {
      value.whenSuccess((success) {
        lessonRoadmaps = success;
        notifyListeners();
      });
    });
  }
}
