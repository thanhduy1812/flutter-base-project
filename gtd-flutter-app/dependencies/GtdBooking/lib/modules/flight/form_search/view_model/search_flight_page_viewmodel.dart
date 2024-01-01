import 'package:easy_localization/easy_localization.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/date_itinerary_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/location_info_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/passengers_inerary_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:rxdart/rxdart.dart';

class SearchFlightPageViewModel extends BasePageViewModel {
  LocationInfoViewModel locationInfoViewModel = LocationInfoViewModel();
  PassengersItineraryViewModel passengerViewModel = PassengersItineraryViewModel();
  DateItineraryViewModel dateItineraryViewModel = DateItineraryViewModel();
  late final bool isCombo;
  Stream<bool> get isEnableSearch => Rx.combineLatest2(
          locationInfoViewModel.validFormController.stream, dateItineraryViewModel.validFormController.stream, (a, b) {
        return a && b;
      });

  SearchFlightPageViewModel({this.isCombo = false}) {
    title = 'global.bookFlight'.tr();
  }

  void updateFromCache(SearchFlightFormModel searchFlightFormModel) {
    if (!isCombo) {
      locationInfoViewModel.fromLocation.destination = searchFlightFormModel.fromLocation;
      locationInfoViewModel.toLocation.destination = searchFlightFormModel.toLocation;
      dateItineraryViewModel.departDate.selectedDate = searchFlightFormModel.departDate;
      dateItineraryViewModel.returnDate.selectedDate = searchFlightFormModel.returnDate;
      dateItineraryViewModel.isRoundTrip = searchFlightFormModel.isRoundTrip;
      locationInfoViewModel.validateForm();
      dateItineraryViewModel.validateForm();
    }
  }

  SearchFlightFormModel get searchInfoFlightVM {
    SearchFlightFormModel searchInfoFlightVM = SearchFlightFormModel(
        fromLocation: locationInfoViewModel.fromLocation.destination,
        toLocation: locationInfoViewModel.toLocation.destination,
        isRoundTrip: dateItineraryViewModel.isRoundTrip)
      ..departDate = dateItineraryViewModel.departDate.selectedDate
      ..returnDate = dateItineraryViewModel.returnDate.selectedDate
      ..adult = passengerViewModel.adultVM.value
      ..child = passengerViewModel.childVM.value
      ..infant = passengerViewModel.infantVM.value;
    return searchInfoFlightVM;
  }
}
