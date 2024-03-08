import 'package:english_app_bme/home/model/feed_back_model.dart';
import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

class FeedbackViewModel extends BaseViewModel {
  List<FeedbackModel> feedbackModels = [];
  FeedbackViewModel() {
    feedbackModels = [
      FeedbackModel(question: "Học viên hiểu bài không", rating: LessonRating.happy),
      FeedbackModel(question: "Học viên vui không", rating: LessonRating.normal),
      FeedbackModel(question: "Học viên chán không", rating: LessonRating.happy)
    ];
  }
}
