import 'package:flutter/material.dart';
import 'package:gtd_repository/gtd_repository.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

class HotelSearchDetailListRoomViewModel extends BaseViewModel {
  bool isExpand;
  bool isEmptyRoom = false;
  double? comparePrice;
  String tripId = "";
  late final ValueNotifier<bool> isExpandNotifer = ValueNotifier(isExpand);
  late GtdHotelRoomDetailDTO hotelRoomDetailDTO;
  String hotelName = "";

  bool shouldHaveExpand = true;
  bool available = true;
  int? totalNight;

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
      ..totalNight = hotelRoomDetailDTO.numberNights
      ..isExpand = hotelRoomDetailDTO.ratePlans.length == 1;

    if (hotelRoomDetailDTO.ratePlans.length == 1) {
      viewModel.shouldHaveExpand = false;
      if ((hotelRoomDetailDTO.ratePlans.first.totalPrice ?? 0) <= 0) {
        viewModel.available = false;
      }
    }

    return viewModel;
  }

  @override
  void dispose() {
    isExpandNotifer.dispose();
    super.dispose();
  }
}
