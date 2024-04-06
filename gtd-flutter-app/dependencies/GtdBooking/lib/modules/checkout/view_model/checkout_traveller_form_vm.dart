import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/checkout/view_model/ssr_item_vm.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/models/request/add_booking_traveller_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_gender.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:gtd_utils/utils/cubit/gtd_text_field_validation_cubit.dart';

import 'gtd_service_field_vm.dart';

enum FieldType {
  firstName("first name"),
  lastName("last name"),
  birthDay("birthday"),
  phone("phone number"),
  email("email");

  final String rawValue;

  const FieldType(this.rawValue);
}

enum CheckoutTravellerFormType { traveler, contact, profile, presenterHotel }

class CheckoutTravellerFormVM {
  final ValueKey<int> position;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<GtdValidateFieldVM> listTFVM = [];
  TravelerInputInfoDTO? travelerInputInfoDTO;

  // bool isValid;
  bool isContact;
  bool isRoundTrip;
  String adultTitle;
  FlightAdultType adultType;
  GtdGender? gender;
  CheckoutTravellerFormType formType;
  late GtdInputTextFieldVM lastName;
  late GtdInputTextFieldVM firstName;
  late GtdInputTextFieldVM fullName;
  late GtdInputTextFieldVM email;
  late GtdInputTextFieldVM phoneNumber;
  late GtdSelectDateTextFieldVM birthDay;
  GtdServiceFieldVM? departBaggage;
  GtdServiceFieldVM? returnBaggage;
  List<String>? cardNumbers;

  List<SsrItemVM> get serviceRequests => [
        departBaggage?.selectedSsrVM,
        returnBaggage?.selectedSsrVM
      ].whereType<SsrItemVM>().toList();

  List<SsrItemVM> get departServiceRequests => serviceRequests
      .where((element) => element.data.bookingDirection == FlightDirection.d)
      .toList();

  List<SsrItemVM> get returnServiceRequests => serviceRequests
      .where((element) => element.data.bookingDirection == FlightDirection.r)
      .toList();

  String get shortInfoPassenger {
    return "$fullNamePassenger, ${birthDay.text}";
  }

  String get fullNamePassenger {
    return "${lastName.text} ${firstName.text}";
  }

  String get fullNameContact {
    return fullName.text;
  }

  CheckoutTravellerFormVM({
    required this.position,
    // required this.isValid,
    required this.isRoundTrip,
    this.formType = CheckoutTravellerFormType.traveler,
    this.adultTitle = '',
    this.adultType = FlightAdultType.adult,
    this.gender = GtdGender.male,
    String? lastName,
    String? firstName,
    String? fullName,
    String? email,
    String? phoneNumber,
    DateTime? birthDay,
    this.cardNumbers,
    this.isContact = false,
  }) {
    if (adultTitle.isEmpty) {
      if (formType == CheckoutTravellerFormType.traveler) {
        adultTitle = 'Người lớn ${position.value + 1}';
      }
      if (formType == CheckoutTravellerFormType.presenterHotel) {
        // adultTitle = 'Đại diện phòng ${position.value + 1}';
        adultTitle = 'Đại diện phòng';
      }
    }
    departBaggage = GtdServiceFieldVM(label: 'checkout.baggageDeparture'.tr());
    if (isRoundTrip) {
      returnBaggage = GtdServiceFieldVM(label: 'checkout.baggageReturn'.tr());
    }

    this.lastName = GtdInputTextFieldVM(
      type: GtdTextFieldType.none,
      inputValidateBehavior: GtdInputValidateBehavior.auto,
      inputUserBehavior: GtdInputUserBehavior.typing,
      text: lastName ?? "",
      groupTitle: adultTitle,
      label: "Họ người liên hệ",
      placeholder: "Họ người liên hệ",
      allowEmpty: false,
      showRequired: true,
    );
    this.firstName = GtdInputTextFieldVM(
      type: GtdTextFieldType.none,
      inputValidateBehavior: GtdInputValidateBehavior.auto,
      inputUserBehavior: GtdInputUserBehavior.typing,
      text: firstName ?? "",
      groupTitle: adultTitle,
      label: "Tên đệm và tên",
      placeholder: "Tên đệm và tên",
      allowEmpty: false,
      showRequired: true,
    );
    this.fullName = GtdInputTextFieldVM(
      type: GtdTextFieldType.name,
      inputValidateBehavior: GtdInputValidateBehavior.auto,
      inputUserBehavior: GtdInputUserBehavior.selection,
      text: fullName ?? "",
      groupTitle: adultTitle,
      label: "Họ tên",
      placeholder: "Họ tên của người liên hệ",
      allowEmpty: false,
    );
    this.email = GtdInputTextFieldVM(
      type: GtdTextFieldType.email,
      inputUserBehavior: GtdInputUserBehavior.selection,
      inputValidateBehavior: GtdInputValidateBehavior.auto,
      text: email ?? "",
      groupTitle: adultTitle,
      label: "Email liên hệ",
      placeholder: "Email liên hệ",
      allowEmpty: false,
      hasUnderlineBorder: false,
      showRequired: true,
    );
    this.phoneNumber = GtdInputTextFieldVM(
      type: Platform.isIOS
          ? GtdTextFieldType.phoneIOS
          : GtdTextFieldType.phoneAndroid,
      inputUserBehavior: GtdInputUserBehavior.selection,
      inputValidateBehavior: GtdInputValidateBehavior.auto,
      text: phoneNumber ?? "",
      groupTitle: adultTitle,
      label: "Điện thoại liên hệ",
      placeholder: "Điện thoại liên hệ",
      allowEmpty: false,
      showRequired: true,
    );
    this.birthDay = GtdSelectDateTextFieldVM(
      selectedDate: birthDay,
      groupTitle: adultTitle,
      label: "checkout.dob".tr(),
      allowEmpty: false,
    );

    if (formType == CheckoutTravellerFormType.traveler) {
      listTFVM = [this.lastName, this.firstName, this.birthDay];
    } else if (formType == CheckoutTravellerFormType.presenterHotel) {
      listTFVM = [this.lastName, this.firstName];
    } else if (formType == CheckoutTravellerFormType.contact) {
      listTFVM = [this.lastName, this.firstName, this.email, this.phoneNumber];
    }
  }

  void updateAdultTitle(
      {int adultCount = 1, int childCount = 0, int infantCount = 0}) {
    int valuePos = position.value;
    switch (adultType) {
      case FlightAdultType.adult:
        adultTitle = 'Người lớn ${valuePos + 1}';
        break;
      case FlightAdultType.child:
        adultTitle = 'Trẻ em ${valuePos - adultCount + 1}';
        break;
      case FlightAdultType.infant:
        adultTitle = 'Em bé ${valuePos - adultCount - childCount + 1}';
        break;
      default:
    }
  }
}

extension CheckoutTravellerFormMapper on CheckoutTravellerFormVM {
  void updateFromTravelerInputInfoDTO(TravelerInputInfoDTO inputInfoDTO) {
    travelerInputInfoDTO = inputInfoDTO;
    gender = inputInfoDTO.gender;
    firstName.text = inputInfoDTO.firstName;
    lastName.text = inputInfoDTO.lastName;
    phoneNumber.text = inputInfoDTO.phoneNumber;
    email.text = inputInfoDTO.email;
    fullName.text = inputInfoDTO.getFullName;
    birthDay.selectedDate = inputInfoDTO.dob;
  }

  TravelerInputInfoDTO get toInputInfoContact {
    TravelerInputInfoDTO contactInputInfo = TravelerInputInfoDTO(
      fullName: fullNameContact,
      lastName: lastName.text,
      firstName: firstName.text,
      email: email.text,
      phoneNumber: phoneNumber.text,
      dob: birthDay.selectedDate,
      infoType: TravelerInputInfoType.contact,
    );
    return contactInputInfo;
  }

  BookingTravelerInfoRq toTravelerInfo(String bookingNumber) {
    if (birthDay.selectedDate == null || gender == null) {
      throw GtdApiError(message: "Must have birthday");
    }
    TravelerRq traveler = TravelerRq(
      adultType: adultType.value.toUpperCase(),
      firstName: firstName.text,
      gender: gender!.name.toUpperCase(),
      surName: lastName.text,
      bookingNumber: bookingNumber,
      dob: birthDay.selectedDate!,
    );
    var ssrDepart =
        [departBaggage?.selectedSsrVM?.data].whereType<SsrOfferDTO>().toList();
    var ssrReturn =
        [returnBaggage?.selectedSsrVM?.data].whereType<SsrOfferDTO>().toList();
    List<SsrOfferDTO> serviceRequests = [...ssrDepart, ...ssrReturn];
    BookingTravelerInfoRq travelerInfo = BookingTravelerInfoRq(
        traveler: traveler, serviceRequests: serviceRequests);
    return travelerInfo;
  }

  BookingContactRq toBookingContact(String bookingNumber) {
    List<String> splitNames = fullName.text.split(" ");
    if (splitNames.length < 2) {
      throw GtdApiError(message: "Fullname must greater than 2 words");
    }

    String surName = splitNames.first;
    String firstName = fullName.text.replaceRange(0, surName.length, "").trim();
    BookingContactRq contact = BookingContactRq(
        email: email.text,
        firstName: firstName,
        phoneNumber1: phoneNumber.text,
        surName: surName,
        bookingNumber: bookingNumber);
    return contact;
  }
}
