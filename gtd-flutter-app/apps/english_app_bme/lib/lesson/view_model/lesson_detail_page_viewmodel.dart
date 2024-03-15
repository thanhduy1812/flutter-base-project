import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/lesson_roadmap_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/user_feedback_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';

class LessonDetailPageViewModel extends BasePageViewModel {
  final BmeOriginCourse course;
  final LessonRoadmapRs lessonRoadmapRs;
  List<BmeUser> bmeUsers = [];
  List<UserFeedback> userFeedbacks = [];
  // Map<int, List<UserFeedback>> userFeedbackDict = {};
  String role = "";
  LessonDetailPageViewModel({required this.course, required this.lessonRoadmapRs}) {
    var bmeUser = CacheHelper.shared.loadSavedObject(BmeUser.fromJson, key: CacheStorageType.accountBox.name);
    role = bmeUser?.role ?? "USER";
    title = lessonRoadmapRs.lessonName ?? "";
    loadUserFeebacks(lessonRoadmapRs.id ?? -1);
  }

  void loadUserFeebacks(int lessonRoadmapId) async {
    BmeRepository.shared.getUserFeedbackListByLessonIds([lessonRoadmapId]).then((value) {
      value.whenSuccess((success) {
        userFeedbacks = success;
      });
    });
  }

  LessonRating? ratingByUsername(String username) {
    var feedbacks = userFeedbacks
        .where((element) => element.userName == username)
        .map((e) => int.tryParse(e.feedbackAnswer ?? "unknown"))
        .whereType<int>()
        .toList();
    if (feedbacks.isEmpty) {
      return null;
    }
    var ratingScore = feedbacks.fold(0, (previousValue, element) => previousValue + element) / feedbacks.length;
    return LessonRating.fromValue(ratingScore.toInt());
  }
}
