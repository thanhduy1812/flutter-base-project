import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_custom_input.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_password_input.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:new_gotadi/app/account/log_in/log_in.dart';
import 'package:new_gotadi/app/account/register/view_controller/register_page.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LogInPage extends BaseStatelessPage<LogInPageViewModel> {
  static const String route = '/logIn';

  const LogInPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return KeyboardDismisser(
      child: ReactiveForm(
        formGroup: viewModel.logInForm,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Divider(
                thickness: 1,
                height: 1,
                color: GtdColors.winterWhite,
              ),
              const LogInPageMessage(),
              GtdEmailOrPhoneInput(
                formControlName: LogInFormControlNames.emailOrPhone.value,
                stream: viewModel.emailOrPhoneValidationStream,
              ),
              const SizedBox(height: 16),
              GtdPasswordInput(
                formControlName: LogInFormControlNames.password.value,
                label: 'account.password'.tr(),
                stream: viewModel.passwordValidationStream,
              ),
              const SizedBox(height: 16),
              _logInBtn(pageContext),
              const SizedBox(height: 8),
              _forgotPassword(pageContext),
              const SizedBox(height: 16),
              _register(pageContext),
              SizedBox(
                height: MediaQuery.of(pageContext).size.height * .25,
              ),
              const LogInTermsAndConditions(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPassword(BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GtdTapWidget(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              '${'account.forgotPassword'.tr()}?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: GtdColors.appMainColor(pageContext),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _register(BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GtdTapWidget(
        onTap: () {
          pageContext.push(RegisterPage.route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'account.noAccountMessage.noAccount'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: GtdColors.inkBlack,
                    ),
                  ),
                  TextSpan(
                    text: 'account.noAccountMessage.signUpNow'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: GtdColors.appMainColor(pageContext),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logInBtn(BuildContext pageContext) {
    return StreamBuilder<bool>(
      stream: viewModel.buttonEnableStream,
      builder: (context, snapshot) {
        bool enabled = snapshot.hasData && snapshot.data == true;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GtdTapWidget(
            onTap: () {
              if (enabled) {
                _processLogin(context);
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
                  'account.logIn'.tr(),
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

  _processLogin(BuildContext context) {
    viewModel.onLogin(
      onError: (message) {
        GtdPopupMessage(context).showError(
          title: 'account.notification'.tr(),
          error: message,
        );
      },
      onSuccess: () {
        context.pop();
      },
    );
  }
}
