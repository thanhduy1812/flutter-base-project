import 'package:gtd_booking/modules/checkout/view_model/ssr_item_vm.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/utils/cubit/gtd_text_field_validation_cubit.dart';

class GtdServiceFieldVM extends GtdValidateFieldVM {
  SsrItemVM? selectedSsrVM;
  GtdServiceFieldVM({
    super.label,
    super.placeholder,
    super.groupTitle,
    super.hintLabel,
    super.text,
    this.selectedSsrVM,
  }) {
    type = GtdTextFieldType.selection;
    inputValidateBehavior = GtdInputValidateBehavior.none;
    inputUserBehavior = GtdInputUserBehavior.selection;
    hasUnderlineBorder = false;
    allowEmpty = true;
  }

  void onSelectedService(SsrItemVM? value) {
    if (value != null) {
      selectedSsrVM = value;
      text = value.itemTitle;
    }
  }
}
