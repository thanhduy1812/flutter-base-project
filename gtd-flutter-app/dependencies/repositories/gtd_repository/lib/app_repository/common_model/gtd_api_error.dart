import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/app_repository/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:collection/collection.dart';

import 'gtd_error_constant.dart';

class GtdApiError extends DVTUtilError {
  // String message = "";
  // String code = "";
  // String localizeMessage = "";
  GtdApiError({super.message = "", super.code = "", super.localizeMessage = ""});
  GtdApiError.fromError({super.message = "", super.code = ""});

  GtdApiError.fromErrorRs(List<ErrorRs> errors) {
    List<GtdErrorConstant> errorConstants = errors
        .map((e) => GtdErrorConstant.findByCode(id: e.id, code: e.code))
        .where((element) => element != GtdErrorConstant.unknown)
        .toSet()
        .toList();
    GtdApiError apiError = fromErrorConstant(errorConstants.firstOrNull ?? GtdErrorConstant.unknown);
    message = apiError.message;
    code = apiError.code;
  }

  GtdApiError.fromErrorsJson(dynamic errors) {
    if (errors is List<ErrorRs>) {
      List<GtdErrorConstant> errorConstants = errors
          .map((e) => GtdErrorConstant.findByCode(id: e.id, code: e.code))
          .where((element) => element != GtdErrorConstant.unknown)
          .toSet()
          .toList();
      GtdApiError apiError = fromErrorConstant(errorConstants.firstOrNull ?? GtdErrorConstant.unknown);
      message = apiError.message;
      code = apiError.code;
    }
  }

  static GtdApiError handleObjectError(dynamic object) {
    if (object is GtdApiError) {
      Logger.e(object.message);
      return object;
    } else {
      Logger.e("Error unknown: $object");
      return fromErrorConstant(GtdErrorConstant.unknown);
    }
  }

  static GtdApiError fromErrorConstant(GtdErrorConstant errorConstant) {
    return GtdApiError(message: errorConstant.message, code: errorConstant.code);
  }

}
