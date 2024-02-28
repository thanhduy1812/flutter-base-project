import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_password_input.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:new_gotadi/app/account/change_password/view_model/change_password_page_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ChangePasswordPage
    extends BaseStatelessPage<ChangePasswordPageViewModel> {
  static const String route = '/change-password';

  const ChangePasswordPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return KeyboardDismisser(
      child: ReactiveForm(
        formGroup: viewModel.form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _warning(),
              GtdPasswordInput(
                formControlName: ChangePasswordFieldNames.currentPassword.value,
                label: ChangePasswordFieldNames.currentPassword.title(),
                stream: viewModel.currentPassStream,
              ),
              const SizedBox(height: 16),
              GtdPasswordInput(
                formControlName: ChangePasswordFieldNames.newPassword.value,
                label: ChangePasswordFieldNames.newPassword.title(),
                stream: viewModel.newPassStream,
                matchStream: viewModel.passwordMatchStream,
              ),
              const SizedBox(height: 16),
              GtdPasswordInput(
                formControlName: ChangePasswordFieldNames.confirmPassword.value,
                label: ChangePasswordFieldNames.confirmPassword.title(),
                stream: viewModel.confirmPassStream,
                matchStream: viewModel.passwordMatchStream,
              ),
              const SizedBox(height: 16),
              _saveBtn(pageContext),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveBtn(BuildContext pageContext) {
    return StreamBuilder<bool>(
      stream: viewModel.buttonEnableStream,
      builder: (context, snapshot) {
        bool enabled = snapshot.hasData && snapshot.data == true;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GtdTapWidget(
            onTap: () {
              if (enabled) {
                viewModel.onSubmit(
                  onSuccess: () {
                    pageContext.pop();
                  },
                  onError: (error) {
                    print('errrorroro $error');
                    ///TODO - show popup error
                  },
                );
              }
            },
            backgroundColor: enabled
                ? GtdColors.appMainColor(pageContext)
                : GtdColors.snowGrey,
            radius: 24,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'global.saveChange'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.white : GtdColors.stormGray,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container _warning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: GtdColors.blueGrey),
        ),
      ),
      child: Text(
        'account.settingsPage.sharePasswordWarning'.tr(),
        style: TextStyle(
          fontSize: 15,
          color: GtdColors.inkBlack,
        ),
      ),
    );
  }
}
