import 'package:gtd_booking/modules/combo/form_search/view_model/combo_passengers_room_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/search_flight_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/hotel/form_search/model/search_hotel_form_model.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/date_checkinout_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/search_hotel_page_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_location_dto.dart';
import 'package:rxdart/rxdart.dart';

class SearchComboPageViewModel extends BasePageViewModel {
  SearchHotelPageViewModel searchHotelViewModel =
      SearchHotelPageViewModel(isCombo: true);
  SearchFlightPageViewModel searchFlightViewModel =
      SearchFlightPageViewModel(isCombo: true)
        ..dateItineraryViewModel.isRoundTrip = true;
  bool enablePickerHotel = false;
  ComboPassengersRoomViewModel passengersRoomViewModel =
      ComboPassengersRoomViewModel();

  final BehaviorSubject<bool> _validFlightFormSubject =
      BehaviorSubject.seeded(false);

  // final BehaviorSubject<bool> _validHotelFormSubject = BehaviorSubject.seeded(false);
  Stream<bool> get isEnableSearchCombo => Rx.combineLatest2(
          _validFlightFormSubject.stream,
          searchHotelViewModel.isEnableButtonStream, (a, b) {
        return a & b;
      });

  SearchComboPageViewModel() {
    title = "Đặt vé combo tiết kiệm";
    if (searchFlightViewModel.dateItineraryViewModel.isRoundTrip == false) {
      enablePickerHotel = true;
      updateStateHotelForm();
    }
    searchFlightViewModel.isEnableSearch.listen((event) {
      updateStateHotelForm();
      _validFlightFormSubject.sink.add(event);
    });
  }

  void toogleHotelDifference() {
    if (searchFlightViewModel.dateItineraryViewModel.isRoundTrip == false) {
      enablePickerHotel = true;
    } else {
      enablePickerHotel = !enablePickerHotel;
    }

    updateStateHotelForm();
  }

  void updateStateHotelForm() {
    updateHotelLocation();
    updateHotelDateCheckin();
  }

  void updateHotelLocation() {
    String locationName = searchFlightViewModel
            .locationInfoViewModel.toLocation.destination.name ??
        "";
    searchHotelViewModel.selectedHotelLocationDTO =
        GtdHotelLocationDTO.initWithLocationName(locationName);
  }

  void updateHotelDateCheckin() {
    if (searchFlightViewModel.dateItineraryViewModel.isRoundTrip) {
      searchHotelViewModel.checkinoutViewModel.pickerMode =
          DateCheckinoutPickerMode.disable;
    } else {
      searchHotelViewModel.checkinoutViewModel.pickerMode =
          DateCheckinoutPickerMode.onlyEnd;
    }
    if (searchFlightViewModel.dateItineraryViewModel.isRoundTrip) {
      searchHotelViewModel.checkinoutViewModel.fromDate.selectedDate =
          searchFlightViewModel.dateItineraryViewModel.departDate.selectedDate;
      searchHotelViewModel.checkinoutViewModel.toDate.selectedDate =
          searchFlightViewModel.dateItineraryViewModel.returnDate.selectedDate;
    } else {
      searchHotelViewModel.checkinoutViewModel.fromDate.selectedDate =
          searchFlightViewModel.dateItineraryViewModel.departDate.selectedDate;
    }
    searchHotelViewModel.checkinoutViewModel.validForm();
  }

  SearchHotelFormModel get searchHotelComboFormModel {
    return SearchHotelFormModel(
      locationDTO: searchHotelViewModel.selectedHotelLocationDTO,
      fromDate: searchHotelViewModel.checkinoutViewModel.fromDate.selectedDate,
      toDate: searchHotelViewModel.checkinoutViewModel.toDate.selectedDate,
      totalAdult: passengersRoomViewModel.totalAdult,
      totalChild: passengersRoomViewModel.totalChild,
      rooms: passengersRoomViewModel.totalRooms,
    );
  }

  SearchFlightFormModel get searchFlightComboFormModel {
    SearchFlightFormModel searchInfoFlightVM = SearchFlightFormModel(
        fromLocation: searchFlightViewModel
            .locationInfoViewModel.fromLocation.destination,
        toLocation:
            searchFlightViewModel.locationInfoViewModel.toLocation.destination,
        isRoundTrip: searchFlightViewModel.dateItineraryViewModel.isRoundTrip)
      ..departDate =
          searchHotelViewModel.checkinoutViewModel.fromDate.selectedDate
      ..returnDate =
          searchHotelViewModel.checkinoutViewModel.toDate.selectedDate
      ..adult = passengersRoomViewModel.totalAdult
      ..child = passengersRoomViewModel.totalChild
      ..infant = passengersRoomViewModel.totalInfant;
    return searchInfoFlightVM;
  }
}
