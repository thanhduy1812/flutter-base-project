import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input_msc.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_password_input.dart';
import 'package:new_gotadi/app/account/register/register.dart';

class RegisterEmailSection extends BaseView<RegisterEmailSectionViewModel> {
  const RegisterEmailSection({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return Column(
      children: [
        GtdSimpleInput(
          formControlName: RegisterFormControlNames.email.value,
          stream: viewModel.emailValidationStream,
          label: 'Email',
          fieldType: GtdInputValidationField.email,
        ),
        const SizedBox(height: 16),
        GtdPasswordInput(
          formControlName: RegisterFormControlNames.password.value,
          label: 'account.password'.tr(),
          stream: viewModel.passwordValidationStream,
          matchStream: viewModel.passwordMatchStream,
        ),
        const SizedBox(height: 16),
        GtdPasswordInput(
          formControlName: RegisterFormControlNames.confirmPassword.value,
          label: 'account.confirmPassword'.tr(),
          stream: viewModel.confirmPasswordValidationStream,
          matchStream: viewModel.passwordMatchStream,
        ),
      ],
    );
  }
}
