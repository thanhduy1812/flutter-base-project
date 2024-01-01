import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_location_dto.dart';
import 'package:gtd_utils/utils/cubit/gtd_text_field_validation_cubit.dart';

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
