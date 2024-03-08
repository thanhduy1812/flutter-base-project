import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';

class FeedbackModel {
  final String question;
  LessonRating rating;

  FeedbackModel({required this.question, required this.rating});
}
