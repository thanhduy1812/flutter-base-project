import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:gtd_booking/modules/checkout/view_model/ssr_item_vm.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/hotel_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:rxdart/rxdart.dart';

import '../../view_model/checkout_traveller_form_vm.dart';
import 'gtd_checkout_content_viewmodel.dart';

class GtdComboCheckoutContentViewModel extends GtdCheckoutContentViewModel {
  bool isFetchedSSR = true;

  final BehaviorSubject<List<SsrItemVM>> ssrItemsSubject = BehaviorSubject<List<SsrItemVM>>();
  Sink<List<SsrItemVM>> get ssrItemsSink => ssrItemsSubject.sink;

  final GtdHotelSearchAllRateRq hotelSearchAllRateRq;
  final SearchFlightFormModel searchFlightFormModel;
  GtdComboCheckoutContentViewModel(
      {required super.bookingDetailDTO, required this.hotelSearchAllRateRq, required this.searchFlightFormModel}) {
    final adultPassengers = List.filled(searchFlightFormModel.adult, FlightAdultType.adult, growable: true);
    final childPassengers = List.filled(searchFlightFormModel.child, FlightAdultType.child, growable: true);
    final infantPassengers = List.filled(searchFlightFormModel.infant, FlightAdultType.infant, growable: true);
    List<CheckoutTravellerFormVM> passengers =
        [...adultPassengers, ...childPassengers, ...infantPassengers].mapIndexed((index, element) {
      var travellerForm = CheckoutTravellerFormVM(
          position: ValueKey(index), adultType: element, isRoundTrip: searchFlightFormModel.isRoundTrip);
      travellerForm.updateAdultTitle(
          adultCount: searchFlightFormModel.adult,
          childCount: searchFlightFormModel.child,
          infantCount: searchFlightFormModel.infant);
      return travellerForm;
    }).toList();
    CheckoutTravellerFormVM contactInfo = CheckoutTravellerFormVM(
        position: const ValueKey(0),
        adultTitle: "Người liên hệ",
        formType: CheckoutTravellerFormType.contact,
        isRoundTrip: true);
    passengersFormSubject.sink.add(passengers);
    contactFormSubject.sink.add(contactInfo);
  }

  void updateFetchedSSRItems(List<SsrOfferDTO> ssrItems) {
    ssrItems.map(
      (ssrDTO) {
        var fareSourceCode = bookingDetailDTO.flightDetailItems
            ?.firstWhere((e) => e.flightDirection == ssrDTO.bookingDirection)
            .flightItem
            .cabinOptions
            ?.first
            .fareSourceCode;
        ssrDTO.fareCode = fareSourceCode ?? "";
        return ssrDTO;
      },
    ).toList();
    var passengers = passengersFormSubject.stream.value;
    var passengersMapped = passengers.map(
      (e) {
        List<SsrItemVM> listServiceVM = ssrItems.map((e) => SsrItemVM(data: e)).toList();
        ssrItemsSink.add(listServiceVM);
        return e;
      },
    ).toList();
    passengersFormSubject.sink.add(passengersMapped);
  }
}
