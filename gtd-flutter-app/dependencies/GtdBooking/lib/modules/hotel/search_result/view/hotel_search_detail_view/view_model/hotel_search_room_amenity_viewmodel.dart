// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/reponse/gtd_hotel_search_result_rs.dart';

class HotelSearchRoomAmenityViewModel extends BaseViewModel {
  bool isExpand;
  List<Amenity> roomAmenities = [];
  HotelSearchRoomAmenityViewModel({
    this.isExpand = false,
  });
  factory HotelSearchRoomAmenityViewModel.fromAmenities(List<Amenity> roomAmenities) {
    HotelSearchRoomAmenityViewModel viewModel = HotelSearchRoomAmenityViewModel(isExpand: false)
      ..roomAmenities = roomAmenities;
    return viewModel;
  }

  List<String> get amenityTitles => roomAmenities.map((e) => e.name).whereType<String>().toList();
}
