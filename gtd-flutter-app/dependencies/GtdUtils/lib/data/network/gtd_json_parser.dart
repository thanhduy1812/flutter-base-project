import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_error_constant.dart';

import 'gtd_app_logger.dart';

class JsonParser {
  static T jsonToModel<T>(T Function(Map<String, dynamic> map) fromJson, Map response) {
    try {
      return fromJson(response.cast());
    } on TypeError catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}', tag: "JsonParser - jsonToModel");
      throw GtdApiError.fromError(code: GtdErrorConstant.typeError.code, message: e.stackTrace.toString());
    } catch (e) {
      rethrow;
    }
  }

  static List<T> jsonArrayToModel<T>(T Function(Map<String, dynamic> map) fromJson, List data) {
    try {
      return data.map((e) => fromJson((e as Map).cast())).toList();
    } on TypeError catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}', tag: "JsonParser - jsonArrayToModel");
      throw GtdApiError.fromError(code: GtdErrorConstant.typeError.code, message: e.stackTrace.toString());
    } catch (e) {
      rethrow;
    }
  }
}
