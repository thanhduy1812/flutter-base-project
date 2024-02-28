import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/authentication_resource/models/request/register_request.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input_msc.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:new_gotadi/app/account/register/register.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPageViewModel extends BasePageViewModel {
  final registerForm = FormGroup(
    {
      RegisterFormControlNames.lastName.value: FormControl<String>(),
      RegisterFormControlNames.firstName.value: FormControl<String>(),
      RegisterFormControlNames.email.value: FormControl<String>(),
      RegisterFormControlNames.password.value: FormControl<String>(),
      RegisterFormControlNames.confirmPassword.value: FormControl<String>(),
    },
  );

  final lastNameValidationStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );

  final firstNameValidationStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );

  late Stream<bool> buttonEnableStream;

  final emailSectionViewModel = RegisterEmailSectionViewModel();
  final phoneSectionViewModel = RegisterPhoneSectionViewModel();

  final tabIndexStream = BehaviorSubject<int>.seeded(0);

  RegisterPageViewModel() {
    title = 'account.registerTitle'.tr();
    backgroundColor = Colors.white;
    _emailSectionVisible();
  }

  _emailSectionVisible() {
    buttonEnableStream = Rx.combineLatest4(
      lastNameValidationStream,
      firstNameValidationStream,
      emailSectionViewModel.emailSectionValidStream,
      tabIndexStream,
      (lastName, firstName, emailSectionValid, tab) {
        if (tab == 1) {
          return false;
        }
        if (lastName != GtdInputValidation.valid ||
            firstName != GtdInputValidation.valid ||
            !emailSectionValid) {
          return false;
        } else {
          return true;
        }
      },
    );
  }

  _phoneSectionVisible() {
    buttonEnableStream = Rx.combineLatest4(
      lastNameValidationStream,
      firstNameValidationStream,
      phoneSectionViewModel.phoneSectionValidStream,
      tabIndexStream,
      (lastName, firstName, phoneSectionValid, tab) {
        if (tab == 0) {
          return false;
        }
        if (lastName != GtdInputValidation.valid ||
            firstName != GtdInputValidation.valid ||
            !phoneSectionValid) {
          return false;
        } else {
          return true;
        }
      },
    );
  }

  onTabChanged(int index) {
    if (index == 0) {
      _emailSectionVisible();
    } else {
      _phoneSectionVisible();
    }
    tabIndexStream.add(index);
  }

  onSubmit({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    GtdLoading.show();
    final response = await GtdAuthenticationRepository.shared.register(
      RegisterRequest(
        login: registerForm.control(RegisterFormControlNames.email.value).value,
        email: registerForm.control(RegisterFormControlNames.email.value).value,
        firstName: registerForm
            .control(RegisterFormControlNames.firstName.value)
            .value,
        lastName:
            registerForm.control(RegisterFormControlNames.lastName.value).value,
        password:
            registerForm.control(RegisterFormControlNames.password.value).value,
      ),
    );
    GtdLoading.hide();
    if (response.isSuccess()) {
    } else {}
  }
}

enum RegisterFormControlNames {
  firstName('firstName'),
  lastName('lastName'),
  email('email'),
  password('password'),
  confirmPassword('confirmPassword');

  const RegisterFormControlNames(this.value);

  final String value;
}
