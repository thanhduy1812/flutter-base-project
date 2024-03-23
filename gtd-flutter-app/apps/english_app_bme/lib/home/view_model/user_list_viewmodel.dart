// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:beme_english/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/user_feedback_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/network/models/wrapped_result/result.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

enum UserListViewMode {
  user,
  mentor;
}

class UserListViewModel extends BaseViewModel {
  List<BmeUser> bmeUsers = [];
  List<UserFeedback> userFeedbacks = [];
  UserListViewMode viewMode = UserListViewMode.user;
  UserListViewModel({this.bmeUsers = const [], this.userFeedbacks = const [], this.viewMode = UserListViewMode.user});

  (LessonRating, double)? ratingByUsername(String username) {
    var feedbacks = userFeedbacks
        .where((element) => element.userName == username)
        .map((e) => int.tryParse(e.feedbackAnswer ?? "unknown"))
        .whereType<int>()
        .toList();
    if (feedbacks.isEmpty) {
      return null;
    }
    var ratingScore = feedbacks.fold(0, (previousValue, element) => previousValue + element) / feedbacks.length;
    return (LessonRating.fromValue(ratingScore.toInt()), ratingScore);
  }

  (LessonRating, double)? ratingByFeedbackTo(String feedbackTo) {
    var feedbacks = userFeedbacks
        .where((element) => element.feedbackTo == feedbackTo)
        .map((e) => int.tryParse(e.feedbackAnswer ?? "unknown"))
        .whereType<int>()
        .toList();
    if (feedbacks.isEmpty) {
      return null;
    }
    var ratingScore = feedbacks.fold(0, (previousValue, element) => previousValue + element) / feedbacks.length;
    return (LessonRating.fromValue(ratingScore.toInt()), ratingScore);
  }

  Future<Result<BmeUser, GtdApiError>> updateUser(BmeUser bmeUser, String courseCode) async {
    bmeUser.tag = courseCode;
    return await BmeRepository.shared.updateBmeUser(bmeUser);
  }
}
