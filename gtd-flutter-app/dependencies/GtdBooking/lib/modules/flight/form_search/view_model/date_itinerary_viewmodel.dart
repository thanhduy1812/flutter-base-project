import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:rxdart/rxdart.dart';

class DateItineraryViewModel extends BaseViewModel {
  bool isRoundTrip = false;
  late GtdSelectDateTextFieldVM departDate;
  late GtdSelectDateTextFieldVM returnDate;
  BehaviorSubject<bool> validFormController = BehaviorSubject.seeded(false);
  DateItineraryViewModel() {
    departDate = GtdSelectDateTextFieldVM(label: "Ngày đi", allowEmpty: false, hasUnderlineBorder: isRoundTrip);
    returnDate = GtdSelectDateTextFieldVM(label: "Ngày về", allowEmpty: false, hasUnderlineBorder: false);
  }
  bool validateForm() {
    bool isValid = false;
    departDate.validateViewModel();
    if (isRoundTrip) {
      returnDate.validateViewModel();
      isValid = departDate.isValid && returnDate.isValid;
    } else {
      isValid = departDate.isValid;
    }
    validFormController.sink.add(isValid);
    return isValid;
  }
}
