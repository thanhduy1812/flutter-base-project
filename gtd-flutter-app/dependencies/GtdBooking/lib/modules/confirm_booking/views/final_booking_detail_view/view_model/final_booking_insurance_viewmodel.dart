import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_detail_rs.dart';

class FinalBookingInsuranceViewModel extends BaseViewModel {
  GtdInsuranceDetail insuranceDetail;
  FinalBookingInsuranceViewModel(this.insuranceDetail);
}
