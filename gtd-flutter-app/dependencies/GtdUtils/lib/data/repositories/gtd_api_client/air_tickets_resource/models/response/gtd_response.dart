import 'package:gtd_utils/data/network/models/gtd_json_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

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
