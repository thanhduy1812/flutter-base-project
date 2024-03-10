import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/add_lesson_rq.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

class AddCoursePageViewModel extends BasePageViewModel {
  final bool isAddLesson;
  String titleField = "";
  DateTime startDate = DateTime.now();
  final BmeOriginCourse course;
  AddCoursePageViewModel({super.title, this.isAddLesson = false, required this.course});

  void setStartDate(DateTime date) {
    startDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void setHourDate(TimeOfDay timeOfDay) {
    DateTime originalDateTime = startDate;
    startDate =
        DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day, timeOfDay.hour, timeOfDay.minute);
    notifyListeners();
  }

  bool validateForm() {
    return titleField.isNotEmpty;
  }

  Future<Result<AddLessonRq, GtdApiError>> createLessonRoadmap() async {
    var lessonRoadmapRq = AddLessonRq(classCode: course.maLop, lessonName: titleField, startDate: startDate);
    return BmeRepository.shared.createLessonRoadmap(addLessonRq: lessonRoadmapRq);
  }
}
