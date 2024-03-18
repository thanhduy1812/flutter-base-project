import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/lesson_roadmap_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/user_feedback_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';

enum LessonRating {
  sad(0),
  normal(5),
  happy(10);

  final int score;

  const LessonRating(this.score);

  static LessonRating caculateRating(List<LessonRating> ratings) {
    double rating =
        ratings.map((e) => e.score).fold(0, (previousValue, element) => previousValue + element) / ratings.length;
    if (rating >= 7) {
      return LessonRating.happy;
    } else if (rating <= 3) {
      return LessonRating.sad;
    } else {
      return LessonRating.normal;
    }
  }

  static LessonRating fromValue(int value) {
    if (value >= 7) {
      return LessonRating.happy;
    } else if (value <= 3) {
      return LessonRating.sad;
    } else {
      return LessonRating.normal;
    }
  }
}

class LessonPageViewModel extends BasePageViewModel {
  final BmeOriginCourse course;
  List<LessonRoadmapRs> lessonRoadmaps = [];
  // Map<int, List<LessonRating>> userFeedbackDict = {};
  List<UserFeedback> userFeedbacks = [];
  String role = "";
  BmeUser? bmeUser;
  List<BmeUser> classUsers = [];
  LessonPageViewModel({required this.course}) {
    title = course.maLop ?? "--";
    var bmeUser = CacheHelper.shared.loadSavedObject(BmeUser.fromJson, key: CacheStorageType.accountBox.name);
    this.bmeUser = bmeUser;
    role = bmeUser?.role ?? "USER";
    loadLessonRoadmaps();
    if (course.maLop != null) {
      loadBmeUsersByClassCode(course.maLop!);
    }
  }

  void loadLessonRoadmaps() async {
    await BmeRepository.shared.findLessonRoadmapByKey(course.maLop!).then((value) {
      value.whenSuccess((success) {
        lessonRoadmaps = success;
        notifyListeners();
      });
    }).then((value) => loadUserFeedbackByLesson());
  }

  void loadUserFeedbackByLesson() async {
    var lessonIds = lessonRoadmaps.map((e) => e.id).whereType<int>().toList();
    await BmeRepository.shared.getUserFeedbackListByLessonIds(lessonIds).then((value) {
      value.whenSuccess((success) {
        // userFeedbackDict = success.fold<Map<int, List<LessonRating>>>({}, (map, element) => map..[element.id]);
        userFeedbacks = success;
        notifyListeners();
      });
    });
  }

  Future<void> loadBmeUsersByClassCode(String classCode) async {
    await BmeRepository.shared.findUserByClassCode(classCode).then((value) {
      value.whenSuccess((success) {
        classUsers = success;
        notifyListeners();
      });
    });
  }

  (LessonRating, double)? arrangeRating(int lessonId) {
    List<int> ratings = userFeedbacks
        .where((element) {
          if (role != "ADMIN") {
            return element.lessonRoadmapId == lessonId && element.userName == bmeUser?.username;
          }
          return element.lessonRoadmapId == lessonId;
        })
        .map((e) => int.tryParse(e.feedbackAnswer ?? "unknown"))
        .whereType<int>()
        .toList();
    if (ratings.isEmpty) {
      return null;
    }
    double average = ratings.reduce((value, element) => value + element) / ratings.length;
    return (LessonRating.fromValue(average.toInt()), average);
  }
}
