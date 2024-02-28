import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/checkout/cubit/flight_checkout_cubit.dart';
import 'package:gtd_booking/modules/checkout/view_model/hotel_checkout_page_viewmodel.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/models/request/add_booking_traveller_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_all_rate_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_gender.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tuple.dart';
import 'package:rxdart/rxdart.dart';

import '../view_model/checkout_traveller_form_vm.dart';

class HotelCheckoutCubit extends Cubit<CheckoutState> {
  HotelCheckoutCubit() : super(CheckoutStateInitial());

  BehaviorSubject<List<CheckoutTravellerFormVM>> passengersFormSubject =
      BehaviorSubject<List<CheckoutTravellerFormVM>>();
  Stream<List<CheckoutTravellerFormVM>> get passengersStream => passengersFormSubject.stream;

  BehaviorSubject<CheckoutTravellerFormVM> contactFormSubject = BehaviorSubject<CheckoutTravellerFormVM>();
  Stream<CheckoutTravellerFormVM> get contactStream => contactFormSubject.stream;

  late BookingDetailDTO bookingDetailDTO;
  late GtdHotelSearchAllRateRq hotelSearchAllRateRq;
  bool isRoundTrip = false;

  void initPassengers(HotelCheckoutPageViewModel viewModel) {
    if (viewModel.bookingDetailDTO == null) {
      Logger.e("initPassengers-BookingDetailDTO is null");
      throw GtdApiError(message: "BookingDetailDTO is null");
    }
    bookingDetailDTO = viewModel.bookingDetailDTO!;
    hotelSearchAllRateRq = viewModel.searchAllRateRq;
    isRoundTrip = bookingDetailDTO.roundType == "Roundtrip";
    //Init fake data
    List<CheckoutTravellerFormVM> passengers = [1, 2, 3, 4].mapIndexed((index, element) {
      var travellerForm = CheckoutTravellerFormVM(position: ValueKey(index), isRoundTrip: isRoundTrip);
      travellerForm.updateAdultTitle(adultCount: 2);
      return travellerForm;
    }).toList();
    CheckoutTravellerFormVM contactInfo =
        CheckoutTravellerFormVM(position: const ValueKey(0), adultTitle: "Người liên hệ", isRoundTrip: isRoundTrip);

    passengersFormSubject.add(passengers);
    contactFormSubject.add(contactInfo);
  }

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
    passengersFormSubject.add(passengers);
  }

  void updatePassengerFromTravelerInputInfo({required ValueKey key, required TravelerInputInfoDTO infoDTO}) {
    List<CheckoutTravellerFormVM> passengers = passengersFormSubject.value;
    CheckoutTravellerFormVM? updatePassenger = passengers.firstWhereOrNull((element) => element.position == key);
    updatePassenger?.updateFromTravelerInputInfoDTO(infoDTO);
    passengersFormSubject.add(passengers);
  }

  void updateContact({ValueKey? key, String? fullName, String? phoneNumber, String? email, bool? isValid}) {
    CheckoutTravellerFormVM contact = contactFormSubject.value;
    contact.fullName.onSelectedValue(fullName);
    contact.phoneNumber.onSelectedValue(phoneNumber);
    contact.email.onSelectedValue(email);
    contactFormSubject.add(contact);
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

  Future<Result<String, GtdApiError>> addBookingTraveller() async {
    String bookingNumber = bookingDetailDTO.bookingNumber!;
    try {
      List<BookingContactRq> contacts = [contactFormSubject.value.toBookingContact(bookingNumber)];
      List<CheckoutTravellerFormVM> passengers = passengersFormSubject.value;
      List<BookingTravelerInfoRq> travellerInfos = passengers.map((e) => e.toTravelerInfo(bookingNumber)).toList();
      AddBookingTravellerRq addBookingTravellerRq = AddBookingTravellerRq(
          bookingNumber: bookingNumber,
          bookingContacts: contacts,
          bookingTravelerInfos: travellerInfos,
          taxReceiptRequest: TaxReceiptRequest(bookingNumber: bookingNumber));
      var result = await GtdFlightRepository.shared.addBookingTraveller(addBookingTravellerRq).then((value) async {
        var mappingResult = value.when<Result<String, GtdApiError>>((success) {
          return Success(bookingNumber);
        }, (error) {
          return Error(error);
        });
        return mappingResult;
      });
      return result;
    } on GtdApiError catch (e) {
      Logger.e(e.message);
      return Error(e);
    } catch (e) {
      Logger.e(e.toString());
      return Error(GtdApiError(message: "Error addbooking traveller"));
    }
  }

  //MARK: Stream valid all field and enable/disable button
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
        return isEnable;
        // return result ?? true;
      });
  Stream<bool> get searchButtonValidStream => validationPassengersInput().asStream().map((event) => event.item1);

  @override
  Future<void> close() {
    passengersFormSubject.close();
    contactFormSubject.close();
    return super.close();
  }
}
