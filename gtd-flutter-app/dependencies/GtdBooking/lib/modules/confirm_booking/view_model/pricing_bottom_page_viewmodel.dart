import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/customer_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/models/response/gtd_saved_company_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/request/gtd_insurance_plan_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/meta_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_insurance_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';

import '../../checkout/view_model/checkout_traveller_form_vm.dart';
import '../../checkout/view_model/gtd_display_price_item_vm.dart';
import 'price_bottom_detail_viewmodel.dart';

class PricingBottomPageViewModel extends BasePageViewModel {
  String? bookingNumber;
  BookingDetailDTO? _bookingDetailDTO;

  BookingDetailDTO? get bookingDetailDTO => _bookingDetailDTO;

  set bookingDetailDTO(BookingDetailDTO? value) {
    subTitle = value?.flightDetailItems?.firstOrNull?.inineraryPassengerTitle ?? "";
    bookingNumber = value?.bookingNumber ?? "";
    Future.delayed(Duration.zero, () {
      subTitleNotifer.value = subTitle ?? "";
    });

    _bookingDetailDTO = value;
  }

  List<TravelerInputInfoDTO> travelerInputInfos = [];
  TravelerInputInfoDTO? contactInputInfo;
  List<GtdSavedTravellerRs> savedTravellers = [];
  List<GtdSavedCompanyRs> savedCompanies = [];
  List<GtdCountryCodeRs> countries = [];
  GtdInvoiceBookingInfo? invoiceBookingInfo;

  late PriceBottomViewModel priceBottomViewModel;

  PricingBottomPageViewModel({this.bookingNumber, BookingDetailDTO? bookingDetailDTO})
      : _bookingDetailDTO = bookingDetailDTO;

  double get netAmount {
    if (bookingDetailDTO != null) {
      double ssrTotalAmount = travelerInputInfos
          .map((e) => e.selectedServices)
          .flattened
          .map((e) => e.ssrAmount)
          .fold(0, (previousValue, element) => previousValue + element);
      return bookingDetailDTO!.tempAmount + ssrTotalAmount;
    } else {
      return 0;
    }
  }

  String get bottomPriceTitle => "Tổng tiền/ tổng khách";

  List<SsrOfferDTO> get selectedSsrItems {
    var result = travelerInputInfos.map((e) => e.selectedServices).flattened.toList();
    return result;
  }

  PriceBottomDetailViewModel get priceBottomDetailViewModel {
    PriceBottomDetailViewModel viewModel = PriceBottomDetailViewModel.fromBookingDetailDTO(bookingDetailDTO!);
    //Update listItem
    List<GtdDisplayPriceItemVM> flightServiceVms = ServiceType.values
        .where((element) => element != ServiceType.insurance)
        .map((e) => GtdDisplayPriceItemVM.flightFromSsrOfferDTOs(items: selectedSsrItems, serviceType: e))
        .where((element) => element.price != 0)
        .toList();
    List<GtdDisplayPriceItemVM> insuranceServiceVms = GtdInsuranceType.values
        .map((e) => GtdDisplayPriceItemVM.insuranceFromSsrOfferDTOs(items: selectedSsrItems, insuranceType: e))
        .where((element) => element.price != 0)
        .toList();
    double serviceSSR = [...flightServiceVms, ...insuranceServiceVms].map((e) => e.price).toList().sum;
    viewModel.items.addAll([...flightServiceVms, ...insuranceServiceVms]);
    // viewModel.items.sorted((a, b) => a.type.position.compareTo(b.type.position)).toList();
    viewModel.items.sort((a, b) => a.type.position.compareTo(b.type.position));
    //Update totalPrice
    viewModel.totalPriceVM.price = (bookingDetailDTO?.tempAmount ?? 0) + serviceSSR;
    return viewModel;
  }

  void confirmListTravelerDTOS(
      List<CheckoutTravellerFormVM> checkoutTravellerFormVMs, CheckoutTravellerFormVM contactFormVM) {
    travelerInputInfos =
        checkoutTravellerFormVMs.map((e) => e.travelerInputInfoDTO).whereType<TravelerInputInfoDTO>().toList();
    contactInputInfo = contactFormVM.toInputInfoContact;
  }

  GtdInsurancePlanRq createInsuranceRequest({int planId = 1}) {
    var fromLocation =
        bookingDetailDTO?.flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.originLocation?.locationCode ?? "";
    var toLocation = bookingDetailDTO
            ?.flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.destinationLocation?.locationCode ??
        "";
    var departureDate = bookingDetailDTO?.flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.originDateTime;
    var returnDate = bookingDetailDTO?.flightDetailItems?.lastOrNull?.flightItem.flightItemInfo?.destinationDateTime;
    GtdInsurancePlanRq insurancePlanRq = GtdInsurancePlanRq(
        bookingNumber: bookingDetailDTO!.bookingNumber!,
        planId: planId,
        numberOfNonIns: 0,
        infant: 0,
        adult: 1,
        child: 0,
        fromLocation: fromLocation,
        toLocation: toLocation,
        departureDate: departureDate!,
        returnDate: returnDate);
    if (kDebugMode) {
      print(insurancePlanRq.toJson());
    }
    return insurancePlanRq;
  }

  bool checkAllowedBuyFlexiInsurance(bool stepConfirm) {
    bool isAllowed = true;
    var departureDate = bookingDetailDTO!.flightDetailItems!.first.flightItem.flightItemInfo!.originDateTime!;
    var age85FromNow = DateTime(departureDate.year - 85, departureDate.day, departureDate.hour);
    var age6FromNow = DateTime(departureDate.year - 6, departureDate.day, departureDate.hour);
    var age12FromNow = DateTime(departureDate.year - 12, departureDate.day, departureDate.hour);
    var age18FromNow = DateTime(departureDate.year - 18, departureDate.day, departureDate.hour);
    if (bookingDetailDTO?.isOneWay == true) {
      return false;
    }
    var numberValidPerson = travelerInputInfos
        .map((e) => e.dob)
        .whereType<DateTime>()
        .where((element) {
          return element.isAfter(age85FromNow) && element.isBefore(age6FromNow);
        })
        .toList()
        .length;
    if (numberValidPerson == 0) {
      return false;
    }
    if (travelerInputInfos.length == 1) {
      var dobTraveler = travelerInputInfos.first.dob!;
      if (dobTraveler.isBefore(age85FromNow) || dobTraveler.isAfter(age12FromNow)) {
        return false;
      }
    } else {
      var numberValidAdult = travelerInputInfos
          .map((e) => e.dob)
          .whereType<DateTime>()
          .where((element) {
            return element.isAfter(age85FromNow) && element.isBefore(age18FromNow);
          })
          .toList()
          .length;
      var numberChildLessThan12 = travelerInputInfos
          .map((e) => e.dob)
          .whereType<DateTime>()
          .where((element) {
            return element.isAfter(age12FromNow);
          })
          .toList()
          .length;
      if (numberChildLessThan12 > 0 && numberValidAdult < 1) {
        return false;
      }
    }

    if (stepConfirm) {
      //Check to show Popup input contact Dob
      var contactDob = contactInputInfo?.dob;
      if (contactDob == null || contactDob.isAfter(age18FromNow)) {
        return false;
      }
    }

    return isAllowed;
  }
}
