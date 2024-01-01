// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view_model/hotel_summary_item_viewmodel.dart';

class ComboSummaryItemViewModel extends BaseViewModel {
  final List<FlightSummaryItemViewModel> flightItemViewModels;
  final HotelSummaryItemViewModel hotelItemViewModel;

  ComboSummaryItemViewModel({
    required this.flightItemViewModels,
    required this.hotelItemViewModel,
  });

  String get flightInfo {
    if (flightItemViewModels.length == 1) {
      String originCode = flightItemViewModels.first.originCode;
      String destinationCode = flightItemViewModels.first.destinationCode;
      String departDate = flightItemViewModels.first.departDate;
      String arrivalDate = flightItemViewModels.first.arrivalDate;
      return "Một chiều $originCode - $destinationCode | $departDate - $arrivalDate";
    } else {
      String originCode = flightItemViewModels.first.originCode;
      String destinationCode = flightItemViewModels.first.destinationCode;
      String departDate = flightItemViewModels.first.departDate;
      String arrivalDate = flightItemViewModels.last.arrivalDate;
      return "Khứ hồi $originCode - $destinationCode | $departDate - $arrivalDate";
    }
  }

  String get hotelInfo {
    String hotelName = hotelItemViewModel.titleHeader;
    String hotelRoomInfo = "${hotelItemViewModel.totalRooms} phòng, ${hotelItemViewModel.nights} đêm";
    return "$hotelName | $hotelRoomInfo";
  }
}
