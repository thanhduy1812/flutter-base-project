import 'package:gtd_repository/app_repository/common_model/gtd_api_error.dart';
import 'package:gtd_repository/app_repository/common_model/gtd_json_model.dart';
import 'gtd_error_rs.dart';
import 'gtd_info_rs.dart';

class GtdResponse extends GTDJsonModel {
  GtdResponse({
    this.duration,
    this.errors,
    this.infos,
    this.isSuccess,
    this.success,
    this.textMessage,
  });

  int? duration;
  List<ErrorRs>? errors;
  List<InfoRs>? infos;
  bool? isSuccess;
  bool? success;
  String? textMessage;

  GtdApiError? get apiError => success == false ? GtdApiError.fromErrorsJson(errors ?? []) : null;
}
