import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/authentication_resource/models/request/change_password_request.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input_msc.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordPageViewModel extends BasePageViewModel {
  ChangePasswordPageViewModel() {
    title = 'account.settingsPage.changePassword'.tr();
    backgroundColor = Colors.white;
    form = FormGroup({
      ChangePasswordFieldNames.currentPassword.value: FormControl<String>(),
      ChangePasswordFieldNames.newPassword.value: FormControl<String>(),
      ChangePasswordFieldNames.confirmPassword.value: FormControl<String>(),
    });
    buttonEnableStream = Rx.combineLatest3(
      currentPassStream,
      newPassStream,
      confirmPassStream,
      (current, newPass, confirmPass) {
        if (current != GtdInputValidation.valid ||
            newPass != GtdInputValidation.valid ||
            confirmPass != GtdInputValidation.valid) {
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

  late FormGroup form;
  final currentPassStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );
  final newPassStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );
  final confirmPassStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );

  final passwordMatchStream = BehaviorSubject<Map<String, String>>.seeded(
    {
      ChangePasswordFieldNames.newPassword.value: '',
      ChangePasswordFieldNames.confirmPassword.value: '',
    },
  );
  late Stream<bool> buttonEnableStream;

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

  onSubmit({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    GtdLoading.show();
    final response = await GtdAuthenticationRepository.shared.changePassword(
      ChangePasswordRequest(
        oldPassword:
            form.control(ChangePasswordFieldNames.currentPassword.value).value,
        newPassword:
            form.control(ChangePasswordFieldNames.newPassword.value).value,
      ),
    );
    GtdLoading.hide();
    if (response.isSuccess()) {
      onSuccess.call();
    } else {
      final error = response.tryGetError();
      final message = error?.errorByCode(
        code: error.code,
        message: error.message,
      );
      onError.call(message?.item2 ?? '');
    }
  }
}

enum ChangePasswordFieldNames {
  currentPassword('currentPassword'),
  newPassword('newPassword'),
  confirmPassword('repeatPassword');

  const ChangePasswordFieldNames(this.value);

  final String value;
}

extension ChangePasswordFieldNamesExt on ChangePasswordFieldNames {
  String title() {
    switch (this) {
      case ChangePasswordFieldNames.currentPassword:
        return 'account.settingsPage.currentPassword'.tr();
      case ChangePasswordFieldNames.newPassword:
        return 'account.settingsPage.newPassword'.tr();
      case ChangePasswordFieldNames.confirmPassword:
        return 'account.confirmPassword'.tr();
    }
  }
}
