// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/reponse/gtd_hotel_search_result_rs.dart';

class HotelSearchPolicyViewModel extends BaseViewModel {
  bool isExpand;
  String checkin = "14:00";
  String checkout = "14:00";
  String policy =
      "Trẻ e ở miễn phí nếu sử dụng giường có sẵn. Nếu cần thêm giường phụ, cần phụ thu thêm.Trẻ e ở miễn phí nếu sử dụng giường có sẵn. Nếu cần thêm giường phụ, cần phụ thu thêm";
  HotelSearchPolicyViewModel({
    this.isExpand = false,
  });

  factory HotelSearchPolicyViewModel.fromPolicies(
      {required List<Amenity> policies, required String checkin, required String checkout}) {
    HotelSearchPolicyViewModel viewModel = HotelSearchPolicyViewModel()
      ..policy = policies.map((e) => e.value).toList().join("\n")
      ..checkin = checkin
      ..checkout = checkout;
    return viewModel;
  }
}
