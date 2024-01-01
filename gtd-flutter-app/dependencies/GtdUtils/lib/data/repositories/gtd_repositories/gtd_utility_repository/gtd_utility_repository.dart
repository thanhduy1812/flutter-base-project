import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/inventory_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/request/gtd_insurance_plan_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_plans_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

class GtdUtilityRepository {
  final InventoryResourceApi inventoryResourceApi = InventoryResourceApi.shared;

  GtdUtilityRepository._();
  static final shared = GtdUtilityRepository._();

  Future<Result<List<GtdInsuranceDetail>, GtdApiError>> getInsuranceDetail({required String bookingNumber}) async {
    try {
      final response = await inventoryResourceApi.getInsuranceDetailByBooking(bookingNumber);
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("getInsuranceDetail: $e");
      return Error(e);
    }
  }

  Future<Result<List<InsurancePlan>, GtdApiError>> getInsurancePlans(
      {required GtdInsurancePlanRq insurancePlanRq}) async {
    try {
      final response = await inventoryResourceApi.getInsurancePlans(insurancePlanRq);
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("getInsurancePlans: $e");
      return Error(e);
    }
  }
}
