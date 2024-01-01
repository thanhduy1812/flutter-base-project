// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:rxdart/rxdart.dart';

enum DateCheckinoutPickerMode { both, onlyEnd, disable }

class DateCheckinoutViewModel extends BaseViewModel {
  DateCheckinoutPickerMode pickerMode = DateCheckinoutPickerMode.both;
  GtdSelectDateTextFieldVM fromDate = GtdSelectDateTextFieldVM(label: "Nhận phòng", allowEmpty: false);
  GtdSelectDateTextFieldVM toDate = GtdSelectDateTextFieldVM(label: "Trả phòng", allowEmpty: false);

  BehaviorSubject<bool> validFormController = BehaviorSubject.seeded(false);

  DateCheckinoutViewModel();

  bool validForm() {
    fromDate.validateViewModel();
    toDate.validateViewModel();
    bool isValid = fromDate.isValid && toDate.isValid;
    validFormController.sink.add(isValid);
    return isValid;
  }

  bool get isDisableStartDate =>
      pickerMode == DateCheckinoutPickerMode.onlyEnd || pickerMode == DateCheckinoutPickerMode.disable;
  bool get isDisableEndate => pickerMode == DateCheckinoutPickerMode.disable;
}
