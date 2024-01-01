import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/models/request/add_booking_traveller_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

class ConfirmBookingPageViewModel extends PricingBottomPageViewModel {
  bool isAcceptTerm = false;

  ConfirmBookingPageViewModel({required super.bookingNumber}) {
    title = "Xác nhận thông tin";
  }

  String get generateSubTitle {
    var numberAdult = travelerInputInfos.where((element) => element.adultType == FlightAdultType.adult).length;
    var numberChild = travelerInputInfos.where((element) => element.adultType == FlightAdultType.child).length;
    var numberInfant = travelerInputInfos.where((element) => element.adultType == FlightAdultType.infant).length;
    var subTitleTemp =
        "${numberAdult > 0 ? "$numberAdult người lớn" : ""}${numberChild > 0 ? " ,$numberChild trẻ em" : ""}${numberInfant > 0 ? " ,$numberInfant em bé" : ""}";
    return subTitleTemp;
  }

  AddBookingTravellerRq get createAddBookingTravellerRq {
    if (contactInputInfo == null || travelerInputInfos.isEmpty) {
      throw GtdApiError(message: "Traveler info is missing");
    }

    String bookingNumber = bookingDetailDTO!.bookingNumber!;
    List<BookingContactRq> contacts =
        [contactInputInfo!.toBookingContactRq].map((e) => e..bookingNumber = bookingNumber).toList();
    List<BookingTravelerInfoRq> travellerInfos =
        travelerInputInfos.map((e) => e..bookingNumber = bookingNumber).map((e) => e.toBookingTravelerInfoRq).toList();
    AddBookingTravellerRq addBookingTravellerRq = AddBookingTravellerRq(
        bookingNumber: bookingNumber,
        bookingContacts: contacts,
        bookingTravelerInfos: travellerInfos,
        bookingNote: "",
        taxReceiptRequest: invoiceBookingInfo?.toReceiptRequest(bookingNumber));
    return addBookingTravellerRq;
  }
}
