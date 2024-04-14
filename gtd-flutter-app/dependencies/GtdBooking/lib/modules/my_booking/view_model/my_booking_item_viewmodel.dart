import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';

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
