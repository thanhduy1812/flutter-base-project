// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_plans_rs.dart';

class GtdInsuranceItemsListViewModel extends BaseViewModel {
  List<InsurancePlan> insurancePlans = [];
  GtdInsuranceItemsListViewModel();
}
