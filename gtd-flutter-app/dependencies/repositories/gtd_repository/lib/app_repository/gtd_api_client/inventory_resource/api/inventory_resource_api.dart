import 'package:dio/dio.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:dvt_network/dvt_network.dart';
import 'package:gtd_repository/app_repository/common_model/gtd_error_constant.dart';

import '../../../common_model/gtd_api_error.dart';
import '../../../common_model/gtd_environment.dart';
import '../gtd_inventory_endpoint.dart';
import '../models/request/gtd_insurance_plan_rq.dart';
import '../models/response/gtd_insurance_detail_rs.dart';
import '../models/response/gtd_insurance_plans_rs.dart';

class InventoryResourceApi {
  GtdNetworkService networkService = GtdNetworkService.shared;
  GTDEnvType envType = GTDEnvType.B2CAPI;

  InventoryResourceApi._();
  static final shared = InventoryResourceApi._();

  Future<List<GtdInsuranceDetail>> getInsuranceDetailByBooking(String bookingNumber) async {
    try {
      final networkRequest = GTDNetworkRequest(
          type: GtdMethod.get, enpoint: GtdInventoryEndpoint.getInsuranceDetail(envType, bookingNumber));
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      GtdInsuranceDetailRs insuranceDetailRs = JsonParser.jsonToModel(GtdInsuranceDetailRs.fromJson, response.data);
      if ((insuranceDetailRs.errors ?? []).isNotEmpty) {
        throw GtdApiError.fromErrorConstant(GtdErrorConstant.unknown);
      }
      return insuranceDetailRs.result ?? [];
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error unknown: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<List<InsurancePlan>> getInsurancePlans(GtdInsurancePlanRq insurancePlanRq) async {
    try {
      final networkRequest =
          GTDNetworkRequest(type: GtdMethod.get, enpoint: GtdInventoryEndpoint.getInsurancePlans(envType));
      networkRequest.queryParams = insurancePlanRq.toMap();
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      GtdInsurancePlanRs insurancePlanRs = JsonParser.jsonToModel(GtdInsurancePlanRs.fromJson, response.data);
      if ((insurancePlanRs.errors ?? []).isNotEmpty) {
        throw GtdApiError.fromErrorConstant(GtdErrorConstant.unknown);
      }
      return insurancePlanRs.result ?? [];
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error unknown: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }
}
