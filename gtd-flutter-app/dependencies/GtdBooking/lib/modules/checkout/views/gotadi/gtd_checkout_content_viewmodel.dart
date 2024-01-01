// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'package:gtd_booking/modules/checkout/view_model/checkout_traveller_form_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_gender.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tuple.dart';
import 'package:rxdart/rxdart.dart';

class GtdCheckoutContentViewModel extends BaseViewModel {
  late List<CheckoutTravellerFormVM> passengers;
  late CheckoutTravellerFormVM contactInfo;
  BehaviorSubject<List<CheckoutTravellerFormVM>> passengersFormSubject =
      BehaviorSubject<List<CheckoutTravellerFormVM>>();
  Stream<List<CheckoutTravellerFormVM>> get passengersStream => passengersFormSubject.stream;

  BehaviorSubject<CheckoutTravellerFormVM> contactFormSubject = BehaviorSubject<CheckoutTravellerFormVM>();
  Stream<CheckoutTravellerFormVM> get contactStream => contactFormSubject.stream;

  final BookingDetailDTO bookingDetailDTO;
  final bool isFlight;

  GtdCheckoutContentViewModel({required this.bookingDetailDTO, this.isFlight = true});

  void updatePassenger(
      {required ValueKey key,
      GtdGender? gender,
      String? firstName,
      String? lastName,
      DateTime? birthDay,
      bool? isValid,
      bool? usedForContact}) {
    List<CheckoutTravellerFormVM> passengers = passengersFormSubject.value;
    CheckoutTravellerFormVM? updatePassenger = passengers.firstWhereOrNull((element) => element.position == key);
    updatePassenger?.gender = gender ?? updatePassenger.gender;
    updatePassenger?.firstName.onSelectedValue(firstName);
    updatePassenger?.lastName.onSelectedValue(lastName);
    updatePassenger?.birthDay.selectedDate = birthDay ?? updatePassenger.birthDay.selectedDate;

    if (usedForContact == true) {
      passengers.map((e) {
        e.isContact = (e.position == key) ? usedForContact! : false;
      }).toList();
      updateContact(fullName: "${updatePassenger?.firstName.text} ${updatePassenger?.lastName.text}");
    } else {
      updatePassenger?.isContact = usedForContact ?? updatePassenger.isContact;
    }
    if (passengersFormSubject.isClosed) {
      passengersFormSubject = BehaviorSubject<List<CheckoutTravellerFormVM>>.seeded(passengers);
    } else {
      passengersFormSubject.sink.add(passengers);
    }
  }

  void updatePassengerFromTravelerInputInfo({required ValueKey key, required TravelerInputInfoDTO infoDTO}) {
    List<CheckoutTravellerFormVM> passengers = passengersFormSubject.value;
    if (infoDTO.isPresentHotel) {
      passengers.map((e) => e.travelerInputInfoDTO?.isPresentHotel = false).toList();
    }
    if (infoDTO.useContact) {
      passengers.map((e) => e.travelerInputInfoDTO?.useContact = false).toList();
      CheckoutTravellerFormVM contactVM = contactFormSubject.value;
      contactVM.updateFromTravelerInputInfoDTO(infoDTO);
      contactFormSubject.add(contactVM);
    }
    CheckoutTravellerFormVM? updatePassenger = passengers.firstWhereOrNull((element) => element.position == key);
    updatePassenger?.updateFromTravelerInputInfoDTO(infoDTO);
    if (passengersFormSubject.isClosed) {
      passengersFormSubject = BehaviorSubject<List<CheckoutTravellerFormVM>>.seeded(passengers);
    } else {
      passengersFormSubject.sink.add(passengers);
    }
  }

  void updateContact({ValueKey? key, String? fullName, String? phoneNumber, String? email, bool? isValid}) {
    CheckoutTravellerFormVM contact = contactFormSubject.value;
    contact.fullName.onSelectedValue(fullName);
    contact.phoneNumber.onSelectedValue(phoneNumber);
    contact.email.onSelectedValue(email);
    contactFormSubject.sink.add(contact);
  }

  Future<Tuple<bool, GlobalKey>> validationPassengersInput() async {
    List<CheckoutTravellerFormVM> passengers = passengersFormSubject.value;
    CheckoutTravellerFormVM contact = contactFormSubject.value;

    List<CheckoutTravellerFormVM> combineForms = [
      ...passengers,
      ...[contact]
    ];
    var errorField = combineForms
        .map((inputVM) {
          return inputVM.listTFVM;
        })
        .flattened
        .map((e) {
          e.validateInput();
          return e.focusfield;
        })
        .where((element) => element.isValid == false)
        .mapIndexed((index, element) {
          return element;
        })
        .toList()
        .firstOrNull;
    return (errorField != null)
        ? Tuple(item1: errorField.isValid, item2: errorField.formFieldKey)
        : Tuple(item1: true, item2: GlobalKey());
  }

  Stream<bool> get isEnableCheckoutBtn => Rx.combineLatest2(passengersStream, contactStream, (a, b) {
        var isValidPassengers = a.map((e) => e.listTFVM).flattened.map((e) => e.validateInput()).firstWhere(
              (element) => element == false,
              orElse: () => true,
            );
        var isValidContact = b.listTFVM.map((e) => e.validateInput()).firstWhere(
              (element) => element == false,
              orElse: () => true,
            );
        var isEnable = (isValidPassengers && isValidContact);
        print("enable button: $isEnable");
        return isEnable;
        // return result ?? true;
      });

  Stream<bool> get searchButtonValidStream => validationPassengersInput().asStream().map((event) => event.item1);

  @override
  void dispose() {
    passengersFormSubject.close();
    contactFormSubject.close();
    super.dispose();
  }
}
