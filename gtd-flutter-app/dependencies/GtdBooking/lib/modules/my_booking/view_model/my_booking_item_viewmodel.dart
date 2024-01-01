import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/booking_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class MyBookingItemViewModel extends BaseViewModel {
  final BookingInfoElement itemBooking;
  MyBookingItemViewModel(this.itemBooking);

  bool get isRoundTrip => itemBooking.roundType == FlightRoundType.roundTrip.value;

  String get departDateStr {
    return itemBooking.departureDate?.localDate("EEE hh:mm, dd/mm/yyyy") ?? "";
  }

  String get returnDateStr {
    return itemBooking.returnDate?.localDate("EEE hh:mm, dd/MM/yyyy") ?? "";
  }

  String get passengersInfo {
    int adult = (itemBooking.travelerInfos ?? [])
        .where((element) => element.adultType == FlightAdultType.adult.value)
        .toList()
        .length;
    int child = (itemBooking.travelerInfos ?? [])
        .where((element) => element.adultType == FlightAdultType.child.value)
        .toList()
        .length;
    int infant = (itemBooking.travelerInfos ?? [])
        .where((element) => element.adultType == FlightAdultType.infant.value)
        .toList()
        .length;
    return "$adult Người lớn${child > 0 ? ",$child Trẻ em" : ""} ${infant > 0 ? ",$infant Em bé" : ""}";
  }
}
