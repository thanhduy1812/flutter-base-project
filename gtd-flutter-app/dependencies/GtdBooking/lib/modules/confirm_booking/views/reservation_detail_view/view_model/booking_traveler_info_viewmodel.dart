import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';

class BookingTravelerInfoViewModel extends BaseViewModel {
  String title = "Thông tin khách hàng";
  String lastName = "Ta";
  String firstName = "Thanh Thuy";
  String gender = "Nam";
  String dob = "22/04/1988";
  String country = "Việt Nam";
  String passportNumber = "705730974";
  String nationality = "Việt Nam";
  String frequentFlyerType = "Lorersum";
  String frequentFlyerNumber = "403970974097";
  String baggageFreeInfo = "7 Kg";
  String baggagePurchaseInfo = "10 Kg - 100,000 VND";
  String mealInfo = "1xBún bò - 80,000 VND";

  BookingTravelerInfoViewModel();
  factory BookingTravelerInfoViewModel.fromTravelerInfoElement(
      {required String title, required TravelerInfoElement traveler, required FlightDirection flightDirection}) {
    var viewModel = BookingTravelerInfoViewModel()
      ..lastName = traveler.surName ?? ""
      ..firstName = traveler.firstName ?? ""
      ..gender = traveler.gender == null
          ? ""
          : traveler.gender?.toLowerCase() == "male"
              ? "Nam"
              : "Nữ"
      ..dob = traveler.dob?.utcDate("dd/MM/yyyy") ?? ""
      ..country = ""
      ..passportNumber = traveler.documentNumber ?? ""
      ..nationality = traveler.documentType ?? ""
      ..frequentFlyerType = traveler.memberCardType ?? ""
      ..frequentFlyerNumber = traveler.memberCardNumber ?? ""
      ..baggageFreeInfo = (traveler.serviceRequests ?? [])
              .where((element) =>
                  element.bookingDirection == flightDirection.value &&
                  element.serviceType?.toUpperCase() == ServiceType.baggare.name &&
                  element.ssrAmount == 0)
              .firstOrNull
              ?.ssrName
              .toString() ??
          ""
      ..baggagePurchaseInfo = (traveler.serviceRequests ?? [])
              .where((element) =>
                  element.bookingDirection == flightDirection.value &&
                  element.serviceType?.toUpperCase() == ServiceType.baggare.name &&
                  element.ssrAmount != 0)
              .firstOrNull
              ?.ssrName
              .toString() ??
          ""
      ..mealInfo = (traveler.serviceRequests ?? [])
              .where((element) =>
                  element.bookingDirection == flightDirection.value &&
                  element.serviceType?.toUpperCase() == ServiceType.meal.name &&
                  element.ssrAmount != 0)
              .firstOrNull
              ?.ssrName ??
          "";
    return viewModel;
  }

  factory BookingTravelerInfoViewModel.fromTravelerInputInfoDTO(
      {required String title, required TravelerInputInfoDTO traveler}) {
    var viewModel = BookingTravelerInfoViewModel()
      ..lastName = traveler.lastName
      ..firstName = traveler.firstName
      ..gender = traveler.gender == null
          ? ""
          : traveler.gender == GtdGender.male
              ? "Nam"
              : "Nữ"
      ..dob = traveler.dob?.utcDate("dd/MM/yyyy") ?? ""
      ..country = ""
      ..passportNumber = traveler.passport
      ..nationality = traveler.nationality
      ..frequentFlyerType = traveler.membershipType
      ..frequentFlyerNumber = traveler.membershipCard
      ..baggageFreeInfo = (traveler.selectedServices)
              .where((element) => element.serviceType == ServiceType.baggare && element.ssrAmount == 0)
              .firstOrNull
              ?.ssrName
              .toString() ??
          ""
      ..baggagePurchaseInfo = (traveler.selectedServices)
              .where((element) =>
                  // element.bookingDirection == flightDirection.value &&
                  element.serviceType == ServiceType.baggare && element.ssrAmount != 0)
              .firstOrNull
              ?.ssrName
              .toString() ??
          ""
      ..mealInfo = (traveler.selectedServices)
              .where((element) =>
                  // element.bookingDirection == flightDirection.value &&
                  element.serviceType == ServiceType.meal && element.ssrAmount != 0)
              .firstOrNull
              ?.ssrName ??
          "";
    return viewModel;
  }
}
