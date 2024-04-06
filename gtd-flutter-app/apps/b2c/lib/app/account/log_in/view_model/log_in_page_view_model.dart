import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/authentication_resource/authentication_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input_msc.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

class LogInPageViewModel extends BasePageViewModel {
  final logInForm = FormGroup(
    {
      'emailOrPhone': FormControl<String>(),
      'password': FormControl<String>(),
    },
  );

  final emailOrPhoneValidationStream =
      BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );

  final passwordValidationStream = BehaviorSubject<GtdInputValidation>.seeded(
    GtdInputValidation.required,
  );
  late Stream<bool> buttonEnableStream;

  LogInPageViewModel() {
    title = 'account.logIn'.tr();
    backgroundColor = Colors.white;
    buttonEnableStream = Rx.combineLatest2(
      emailOrPhoneValidationStream,
      passwordValidationStream,
      (a, b) {
        return a == GtdInputValidation.valid && b == GtdInputValidation.valid;
      },
    );
  }

  onLogin({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    GtdLoading.show();
    final loginResponse = await GtdAuthenticationRepository.shared.logIn(
      LogInRequest(
        username:
            logInForm.control(LogInFormControlNames.emailOrPhone.value).value,
        password: logInForm.control(LogInFormControlNames.password.value).value,
      ),
    );
    if (loginResponse.isSuccess()) {
      final token = loginResponse.tryGetSuccess()?.idToken;
      GtdChannelSettingObject.shared.token = token;
      CacheHelper.shared.cacheAppToken('Bearer ${token ?? ''}');

      final allInfoResponse =
          await GtdAuthenticationRepository.shared.getAllAccountInfo();
      final hiveData = allInfoResponse.$1;
      if (hiveData != null) {
        UserManager.shared.cacheUserData(hiveData);
        UserManager.shared.setLoggedIn(true);
        onSuccess.call();
      } else {
        onError.call(
            allInfoResponse.$2?.message ?? 'global.generalErrorMessage'.tr());
      }
    } else {
      onError.call(loginResponse.tryGetError()?.message ??
          'global.generalErrorMessage'.tr());
    }
    GtdLoading.hide();
  }
}

enum LogInFormControlNames {
  emailOrPhone('emailOrPhone'),
  password('password');

  const LogInFormControlNames(this.value);

  final String value;
}
