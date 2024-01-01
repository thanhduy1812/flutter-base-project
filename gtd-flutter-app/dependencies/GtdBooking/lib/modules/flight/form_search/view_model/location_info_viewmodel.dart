import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:rxdart/rxdart.dart';

import '../model/destination.dart';

class LocationInfoViewModel extends BaseViewModel {
  late SearchInfoLocationVM fromLocation;
  late SearchInfoLocationVM toLocation;
  BehaviorSubject<bool> validFormController = BehaviorSubject.seeded(false);
  LocationInfoViewModel() {
    fromLocation = SearchInfoLocationVM(destination: Destination(), label: "Nơi đi", allowEmpty: false);
    toLocation = SearchInfoLocationVM(
        destination: Destination(), label: "Nơi đến", allowEmpty: false, hasUnderlineBorder: false);
  }

  void updateLocation({Destination? fromDestination, Destination? toDestination}) {
    fromLocation.destination = fromDestination ?? fromLocation.destination;
    toLocation.destination = toDestination ?? toLocation.destination;
    if (fromDestination?.code == toLocation.destination.code) {
      toLocation.destination = Destination();
    }
    if (toDestination?.code == fromLocation.destination.code) {
      fromLocation.destination = Destination();
    }
  }

  void validateForm() {
    bool isValid = false;
    fromLocation.validateViewModel();
    toLocation.validateViewModel();
    isValid = fromLocation.isValid && toLocation.isValid;
    validFormController.sink.add(isValid);
  }
}
