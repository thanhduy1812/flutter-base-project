import 'dart:io';
import 'package:beme_english/home/app_bottom_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

import 'package:beme_english/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/lesson_roadmap_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/user_feedback_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';

import '../model/feed_back_model.dart';

class ImportCSVPageViewModel extends BasePageViewModel {
  List<BmeOriginCourse> courses = [];
  List<UserFeedback> userFeedbacks = [];
  List<LessonRoadmapRs> lessonRoadmaps = [];
  ImportCSVPageViewModel(this.courses) {
    title = "Data Sheet";
    loadUserFeedbacks();
  }

  void loadUserFeedbacks() async {
    await BmeRepository.shared.searchUserFeedbacksByDate("2024-03-28").then((value) {
      value.whenSuccess((success) {
        userFeedbacks = success;
        loadLessonRoadmaps(success.map((e) => e.lessonRoadmapId).whereType<int>().toList());
      });
    });
  }

  Future<void> loadLessonRoadmaps(List<int> lessonRoadmapIds) async {
    var futures = lessonRoadmapIds.map((e) => BmeRepository.shared.findLessonRoadmapById(e)).toList();
    await Future.wait(futures).then((value) {
      var roadmaps = value.whereType<LessonRoadmapRs>().toList();
      lessonRoadmaps = roadmaps;
      notifyListeners();
      return roadmaps;
    });
  }

  Map<String, dynamic> toDataSheet(UserFeedback userFeedback, List<LessonRoadmapRs> lessonRoadmaps) {
    var lessonRoadmap = lessonRoadmaps
        .where(
          (element) => element.id == userFeedback.lessonRoadmapId,
        )
        .firstOrNull;
    var dataSheet = {
      "Lesson Date": lessonRoadmap?.lessonName,
      "Class Code": lessonRoadmap?.classCode,
      "Teacher Name": lessonRoadmap?.mentorName,
      "Student Phone": userFeedback.userName,
      "Question": listQuestion.where((element) => element.id == userFeedback.feedbackId).first.question,
      "Answer": userFeedback.feedbackAnswer,
    };
    return dataSheet;
  }

  List<Map<String, dynamic>> generateDataFeedbacks() {
    return userFeedbacks.map((e) => toDataSheet(e, lessonRoadmaps)).toList();
  }

  Map<String, dynamic> get generateColumn {
    return {
      "Lesson Date": "1",
      "Class Code": "1",
      "Teacher Name": "1",
      "Student Phone": "1",
      "Question": "Question 1",
      "Answer": "1",
    };
  }

  List<FeedbackModel> get listQuestion {
    // Hôm nay tâm trạng bạn thế nào, chia sẻ với bé me nhé!
    var feedbackModels = [
      FeedbackModel(id: 1, question: "Bạn đã thật sự hiểu bài chưa?", rating: LessonRating.happy),
      FeedbackModel(id: 2, question: "Bạn có tập trung học bài không đó?", rating: LessonRating.happy),
      FeedbackModel(id: 3, question: "Bạn có hài lòng về buổi học ngày hôm nay không nè?", rating: LessonRating.happy),
      FeedbackModel(
          id: 4, question: "Hôm nay tâm trạng bạn thế nào, chia sẻ với bé me nhé!", rating: LessonRating.happy),
    ];
    return feedbackModels;
  }

  DataTable generateDataTable() {
    return DataTable(
      headingRowColor: const MaterialStatePropertyAll(appOrangeDarkColor),
      border: TableBorder.all(color: appBlueDeepColor),
      columns: _generateColumns(),
      rows: _generateRows(),
    );
  }

  List<DataColumn> _generateColumns() {
    // var rawData = viewModel.courses.map((e) => e.toDataSheet()).first;
    var rawData = generateColumn;
    var columns = rawData.keys
        .map(
          (e) => DataColumn(label: Text(e)),
        )
        .toList();
    return columns;
  }

  List<DataRow> _generateRows() {
    // var rawData = viewModel.courses.map((e) => e.toDataSheet());
    var rawData = generateDataFeedbacks();
    var rows = rawData
        .map((e) => e.values.map((rawValue) => DataCell(Text(rawValue.toString()))).toList())
        .map((e) => DataRow(cells: e))
        .toList();
    return rows;
  }

  Future<void> exportDataTableToCsv(DataTable dataTable) async {
    List<List<dynamic>> csvData = [];

    // Add header row
    List<dynamic> headerRow = dataTable.columns.map((column) => column.label).toList();
    csvData.add(headerRow);

    // Add data rows
    for (DataRow row in dataTable.rows) {
      List<dynamic> rowData = row.cells.map((cell) => cell.child).toList();
      csvData.add(rowData);
    }

    // Convert data to CSV string
    String csvString = const ListToCsvConverter().convert(csvData);

    // Get the document directory path
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String documentsPath = appDocumentsDirectory.path;

    // Create the output file path
    String filePath = '$documentsPath/data.csv';

    // Write the CSV string to a file
    File file = File(filePath);
    await file.writeAsString(csvString);

    print('CSV file exported to: $filePath');
  }
}
