import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/checkout/view_model/checkout_traveller_form_vm.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_checkout_content_viewmodel.dart';
import 'package:gtd_repository/gtd_repository.dart';

class GtdHotelCheckoutContentViewModel extends GtdCheckoutContentViewModel {
  final GtdHotelSearchAllRateRq hotelSearchAllRateRq;
  GtdHotelCheckoutContentViewModel({required super.bookingDetailDTO, required this.hotelSearchAllRateRq}) {
    var roomPassengers = List.generate(hotelSearchAllRateRq.room, (index) {
      return CheckoutTravellerFormVM(
          position: ValueKey(index), isRoundTrip: true, formType: CheckoutTravellerFormType.presenterHotel);
    }).toList();
    CheckoutTravellerFormVM contactInfo = CheckoutTravellerFormVM(
        position: const ValueKey(0),
        adultTitle: "Người liên hệ",
        formType: CheckoutTravellerFormType.contact,
        isRoundTrip: true);
    passengersFormSubject.sink.add(roomPassengers);
    contactFormSubject.sink.add(contactInfo);
  }
}
