// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_booking/modules/personal_info/model/saved_traveller_model.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/customer_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/meta_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_gender.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';

class InputInfoPassengerPageViewModel extends BasePageViewModel {
  TravelerInputInfoDTO? travelerInputInfoDTO;
  List<GtdSavedTravellerRs> savedTravellers;
  List<GtdCountryCodeRs> countries;
  bool? isMale;

  bool isUseForContact = false;
  bool isSaveTraveller = false;
  bool isPresentHotel = false;
  TravelerInputInfoType infoType = TravelerInputInfoType.traveler;
  List<GtdValidateFieldVM> passengerInfos = [];
  // var genderVM = GtdRadioRowViewModel(groupValue: true);
  FlightAdultType adultType = FlightAdultType.adult;

  GtdInputTextFieldVM lookupOption =
      GtdInputTextFieldVM(label: "Chọn từ loại tài khoản", inputUserBehavior: GtdInputUserBehavior.selection);
  GtdInputTextFieldVM lookupValue = GtdInputTextFieldVM(label: "Nhập số thẻ thành viên");
  var lastNameVM = GtdInputTextFieldVM(label: "Họ", selectType: GtdInputSelectType.name, allowEmpty: false);
  var firstNameVM = GtdInputTextFieldVM(label: "Tên đệm & tên", selectType: GtdInputSelectType.name, allowEmpty: false);
  var dobVM = GtdSelectDateTextFieldVM(label: "Ngày tháng năm sinh", allowEmpty: false);

  var nationalVM = GtdInputTextFieldVM(
      label: "Quốc tịch",
      selectType: GtdInputSelectType.nationality,
      inputUserBehavior: GtdInputUserBehavior.selection);
  var passportVM = GtdInputTextFieldVM(label: "Thông tin pasport", selectType: GtdInputSelectType.passport);
  var countryVM = GtdInputTextFieldVM(
      label: "Quốc gia cấp", selectType: GtdInputSelectType.country, inputUserBehavior: GtdInputUserBehavior.selection);

  bool isShowMemberShip = true;
  InputInfoPassengerPageViewModel(
      {super.title,
      this.travelerInputInfoDTO,
      this.savedTravellers = const [],
      this.countries = const [],
        this.adultType = FlightAdultType.adult,
      bool isDomestic = true}) {
    infoType = travelerInputInfoDTO?.infoType ?? TravelerInputInfoType.traveler;
    if (travelerInputInfoDTO?.infoType == TravelerInputInfoType.presenterHotel) {
      isShowMemberShip = false;
      passengerInfos = [lastNameVM, firstNameVM];
    } else if (travelerInputInfoDTO?.infoType == TravelerInputInfoType.travelerCombo) {
      if (isDomestic) {
        passengerInfos = [lastNameVM, firstNameVM, dobVM];
      } else {
        passengerInfos = [lastNameVM, firstNameVM, dobVM, nationalVM, passportVM, countryVM];
      }
    } else {
      if (isDomestic) {
        passengerInfos = [lastNameVM, firstNameVM, dobVM];
      } else {
        passengerInfos = [lastNameVM, firstNameVM, dobVM, nationalVM, passportVM, countryVM];
      }
    }

    if (travelerInputInfoDTO?.adultType == FlightAdultType.adult) {
      dobVM.maxDate = DateTime(DateTime.now().year - 13, DateTime.now().month, DateTime.now().day);
    } else if (travelerInputInfoDTO?.adultType == FlightAdultType.child) {
      dobVM.maxDate = DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day);
      dobVM.minDate = DateTime(DateTime.now().year - 12, DateTime.now().month, DateTime.now().day);
    } else {
      dobVM.minDate = DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
    }

    if (travelerInputInfoDTO != null) {
      updateFromSelectedTravelerInfoDTO(travelerInputInfoDTO!);
    }
  }

  void updateTraveller(SavedTravellerModel travellerModel) {
    firstNameVM.text = travellerModel.model.firstName ?? "";
    lastNameVM.text = travellerModel.model.surName ?? "";
    if (travellerModel.model.dob != null) {
      dobVM.selectedDate = travellerModel.model.dob;
    }
    isMale = (travellerModel.model.gender == "MALE");
    nationalVM.text = travellerModel.model.country ?? "";
    countryVM.text = travellerModel.model.issuingCountry ?? "";

    travelerInputInfoDTO?.phoneNumber = travellerModel.model.phoneNumber1 ?? "";
    travelerInputInfoDTO?.email = travellerModel.model.email ?? "";
    travelerInputInfoDTO?.dob = travellerModel.model.dob;
    notifyListeners();
  }

  void updateFromSelectedTravelerInfoDTO(TravelerInputInfoDTO travelerInputInfoDTO) {
    isPresentHotel = travelerInputInfoDTO.isPresentHotel;
    isSaveTraveller = travelerInputInfoDTO.saveTraveler;
    isUseForContact = travelerInputInfoDTO.useContact;
    isMale = travelerInputInfoDTO.gender == null
        ? null
        : travelerInputInfoDTO.gender == GtdGender.male
            ? true
            : false;
    firstNameVM.text = travelerInputInfoDTO.firstName;
    lastNameVM.text = travelerInputInfoDTO.lastName;
    dobVM.selectedDate = travelerInputInfoDTO.dob;
    nationalVM.text = travelerInputInfoDTO.nationality;
    countryVM.text = travelerInputInfoDTO.countryName;
    passportVM.text = travelerInputInfoDTO.passport;
  }

  TravelerInputInfoDTO get finalTravelerInfoDTO {
    TravelerInputInfoDTO dto = TravelerInputInfoDTO(
        title: title ?? "Người lớn",
        bookingNumber: "",
        lastName: lastNameVM.text,
        firstName: firstNameVM.text,
        gender: isMale == true ? GtdGender.male : GtdGender.female,
        adultType: adultType,
        infoType: infoType,
        dob: dobVM.selectedDate,
        phoneNumber: travelerInputInfoDTO?.phoneNumber ?? "",
        email: travelerInputInfoDTO?.email ?? "",
        nationality: nationalVM.text,
        countryName: countryVM.text,
        useContact: isUseForContact,
        saveTraveler: isSaveTraveller,
        isPresentHotel: isPresentHotel,
        passport: passportVM.text,
        membershipCard: "",
        membershipType: "");
    return dto;
  }

  void resetInputForm() {
    passengerInfos
        .map((e) => e
          ..text = ""
          ..onChangeValue(""))
        .toList();
    isMale = null;
    isPresentHotel = false;
    isSaveTraveller = false;
    isUseForContact = false;
  }

  void validateForm() {
    passengerInfos.map((e) => e.validateViewModel()).toList();
    notifyListeners();
  }

  bool get isEnableSaveButton {
    return isMale != null &&
        passengerInfos
            // .map((e) => e..validateViewModel())
            .map((e) => e.isValid)
            .where((element) => element == false)
            .toList()
            .isEmpty;
  }
}
