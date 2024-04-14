import 'package:dvt_helper/dvt_helper.dart';

import '../../common_model/gtd_api_error.dart';

import '../../gtd_api_client/customer_resource/customer_resource.dart';
import '../../gtd_api_client/customer_resource/models/response/gtd_saved_company_rs.dart';

class GtdCustomerRepository {
  final CustomerResourceApi customerResourceApi = CustomerResourceApi.shared;

  GtdCustomerRepository._();
  static final shared = GtdCustomerRepository._();

  Future<Result<List<GtdSavedTravellerRs>, GtdApiError>> getSavedTravellers() async {
    try {
      final response = await customerResourceApi.getSavedTravellers();
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("getSavedTravellers: $e");
      return Error(e);
    }
  }

  Future<Result<List<GtdSavedCompanyRs>, GtdApiError>> getSavedCompanies() async {
    try {
      final response = await customerResourceApi.getSavedCompanies("C::A::1|17933");
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("getSavedCompanies: $e");
      return Error(e);
    }
  }
}
