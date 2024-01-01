import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';

class HotelSearchDetailListRoomViewModel extends BaseViewModel {
  bool isExpand;
  bool isEmptyRoom = false;
  double? comparePrice;
  String tripId = "";
  late final ValueNotifier<bool> isExpandNotifer = ValueNotifier(isExpand);
  late GtdHotelRoomDetailDTO hotelRoomDetailDTO;
  String hotelName = "";
  HotelSearchDetailListRoomViewModel({this.isExpand = false}) {
    hotelRoomDetailDTO = GtdHotelRoomDetailDTO();
  }

  factory HotelSearchDetailListRoomViewModel.fromGtdHotelRoomDetailDTO(GtdHotelRoomDetailDTO hotelRoomDetailDTO,
      {String hotelName = "", required String tripId}) {
    HotelSearchDetailListRoomViewModel viewModel = HotelSearchDetailListRoomViewModel()
      ..hotelName = hotelName
      ..tripId = tripId
      ..hotelRoomDetailDTO = hotelRoomDetailDTO
      ..isEmptyRoom = hotelRoomDetailDTO.ratePlans.isEmpty
      ..isExpand = hotelRoomDetailDTO.ratePlans.length == 1;
    return viewModel;
  }

  @override
  void dispose() {
    isExpandNotifer.dispose();
    super.dispose();
  }
}
