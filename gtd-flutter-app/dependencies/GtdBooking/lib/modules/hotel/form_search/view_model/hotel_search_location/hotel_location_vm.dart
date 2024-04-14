import 'package:gtd_utils/base/view_model/cubit/gtd_text_field_validation_cubit.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_repository/gtd_repository.dart';

class HotelLocationTextFieldVM extends GtdValidateFieldVM {
  GtdHotelLocationDTO _location;

  GtdHotelLocationDTO get location => _location;

  set location(GtdHotelLocationDTO value) {
    _location = value;
    text = value.name;
  }

  HotelLocationTextFieldVM({
    required GtdHotelLocationDTO location,
    super.label,
    super.allowEmpty,
    super.type = GtdTextFieldType.selection,
    super.inputUserBehavior = GtdInputUserBehavior.selection,
    super.inputValidateBehavior = GtdInputValidateBehavior.manual,
    super.hasUnderlineBorder,
  }) : _location = location {
    super.label = label;
  }
}
