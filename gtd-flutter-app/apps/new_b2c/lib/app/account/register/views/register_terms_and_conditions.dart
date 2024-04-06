import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';

class RegisterTermsAndConditions extends StatelessWidget {
  const RegisterTermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'account.register.termsAndConditionsMessage.first'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: GtdColors.slateGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              _termsAndConditions(context),
              TextSpan(
                text: 'account.register.termsAndConditionsMessage.second'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: GtdColors.slateGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _termsAndConditions(BuildContext context) {
    return TextSpan(
      text:
          'account.register.termsAndConditionsMessage.termsAndConditions'.tr(),
      style: TextStyle(
        fontSize: 12,
        color: GtdColors.appMainColor(context),
        fontWeight: FontWeight.w400,
      ),
      recognizer: TapGestureRecognizer()..onTap = () {},
    );
  }
}
