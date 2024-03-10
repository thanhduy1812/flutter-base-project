import 'package:easy_localization/easy_localization.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class AddLessonRq {
  String? classCode;
  String? lessonName;
  String? lessonStatus;
  DateTime? startDate;

  AddLessonRq({
    this.classCode,
    this.lessonName,
    this.lessonStatus,
    this.startDate,
  });

  factory AddLessonRq.fromJson(Map<String, dynamic> json) => AddLessonRq(
        classCode: json["classCode"],
        lessonName: json["lessonName"],
        lessonStatus: json["lessonStatus"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
      );

  Map<String, dynamic> toJson() => {
        "classCode": classCode,
        "lessonName": lessonName,
        "lessonStatus": lessonStatus,
        "startDate": DateFormat(iosPattern).format(startDate!),
      };
}
