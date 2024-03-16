// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:beme_english/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/user_feedback_rs.dart';

class UserListViewModel extends BaseViewModel {
  List<BmeUser> bmeUsers = [];
  List<UserFeedback> userFeedbacks = [];
  UserListViewModel({this.bmeUsers = const [], this.userFeedbacks = const []});

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
