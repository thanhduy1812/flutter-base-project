import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input_msc.dart';
import 'package:new_gotadi/app/account/register/register.dart';
import 'package:rxdart/rxdart.dart';

class RegisterEmailSectionViewModel extends BaseViewModel {
  RegisterEmailSectionViewModel() {
    emailSectionValidStream = Rx.combineLatest3(
      emailValidationStream,
      passwordValidationStream,
      confirmPasswordValidationStream,
      (email, password, confirmPassword) {
        if (email != GtdInputValidation.valid ||
            password != GtdInputValidation.valid ||
            confirmPassword != GtdInputValidation.valid) {
          return false;
        } else {
          if (_passwordMatched()) {
            return true;
          }
          return false;
        }
      },
    );
  }

  final emailValidationStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );

  final passwordValidationStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );

  final confirmPasswordValidationStream =
      BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );
  final passwordMatchStream = BehaviorSubject<Map<String, String>>.seeded(
    {
      RegisterFormControlNames.password.value: '',
      RegisterFormControlNames.confirmPassword.value: '',
    },
  );

  late Stream<bool> emailSectionValidStream;

  bool _passwordMatched() {
    bool matched = true;
    final value = passwordMatchStream.value.entries.first.value;
    for (var entry in passwordMatchStream.value.entries) {
      if (entry.value != value) {
        matched = false;
        break;
      }
    }
    return matched;
  }
}
