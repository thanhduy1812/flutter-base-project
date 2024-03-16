import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/bme_client.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/add_lesson_rq.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class AddCoursePageViewModel extends BasePageViewModel {
  final bool isAddLesson;
  String titleField = "";
  DateTime startDate = DateTime.now();
  BmeUser? seletedMentor;
  final BmeOriginCourse? course;
  final bool isEditMode;
  List<BmeUser> mentors = [];
  AddCoursePageViewModel({super.title, this.isAddLesson = false, this.course, this.isEditMode = false}) {
    loadMentors();
  }

  factory AddCoursePageViewModel.initAddLessonPage({required BmeOriginCourse course}) {
    AddCoursePageViewModel viewModel =
        AddCoursePageViewModel(title: "Add a lesson", isAddLesson: true, course: course, isEditMode: false);
    return viewModel;
  }

  factory AddCoursePageViewModel.initEditLessonPage({required BmeOriginCourse course}) {
    return AddCoursePageViewModel(title: "Add a lesson", isAddLesson: true, course: course, isEditMode: true);
  }

  factory AddCoursePageViewModel.initAddcoursePage() {
    return AddCoursePageViewModel(title: "Add a Course", isAddLesson: false, isEditMode: false);
  }

  factory AddCoursePageViewModel.initEditcoursePage(BmeOriginCourse course) {
    AddCoursePageViewModel viewModel =
        AddCoursePageViewModel(title: "Edit this course", course: course, isAddLesson: false, isEditMode: true);
    viewModel.titleField = course.maLop ?? "";
    viewModel.seletedMentor = BmeUser(fullName: course.giaoVienHienTai ?? "");
    viewModel.startDate = dateFormat.parse(course.ngayKhaiGiang ?? "");
    return viewModel;
  }

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
    var lessonRoadmapRq = AddLessonRq(classCode: course?.maLop ?? "", lessonName: titleField, startDate: startDate);
    return BmeRepository.shared.createLessonRoadmap(addLessonRq: lessonRoadmapRq);
  }

  Future<Result<BmeOriginCourse, GtdApiError>> createCourse() async {
    BmeOriginCourse course = BmeOriginCourse(
        maLop: titleField,
        ngayKhaiGiang: startDate.toUtc().toIso8601String(),
        mau: "246",
        dinhHuong: "X",
        giaoVienHienTai: seletedMentor?.fullName ?? "");
    return await BmeRepository.shared.createBmeCourse(course);
  }

  Future<Result<BmeOriginCourse, GtdApiError>> updateCourse() async {
    if (course?.id == null) {
      return Error(GtdApiError(message: "Missing course id!"));
    }
    course?.maLop = titleField;
    course?.ngayKhaiGiang = startDate.toUtc().toIso8601String();
    course?.mau = "246";
    course?.giaoVienHienTai = seletedMentor?.fullName;
    return await BmeRepository.shared.createBmeCourse(course!);
  }

  void loadMentors() async {
    await BmeRepository.shared.findUserByRole("MENTOR").then((value) {
      value.whenSuccess((success) {
        mentors = success;
      });
    });
  }
}
