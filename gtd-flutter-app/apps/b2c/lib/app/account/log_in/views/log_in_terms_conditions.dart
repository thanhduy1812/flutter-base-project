import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';

class LogInTermsAndConditions extends StatelessWidget {
  const LogInTermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'account.termsAndConditionsMessage.first'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: GtdColors.slateGrey,
                ),
              ),
              _termsAndConditions(context),
              TextSpan(
                text: 'account.termsAndConditionsMessage.second'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: GtdColors.slateGrey,
                ),
              ),
              _details(context),
              TextSpan(
                text: 'account.termsAndConditionsMessage.last'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: GtdColors.slateGrey,
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
      text: 'account.termsAndConditionsMessage.termsAndConditions'.tr(),
      style: TextStyle(
        fontSize: 12,
        color: GtdColors.appMainColor(context),
      ),
      recognizer: TapGestureRecognizer()..onTap = () {},
    );
  }

  _details(BuildContext context) {
    return TextSpan(
      text: 'account.termsAndConditionsMessage.details'.tr(),
      style: TextStyle(
        fontSize: 12,
        color: GtdColors.appMainColor(context),
      ),
      recognizer: TapGestureRecognizer()..onTap = () {},
    );
  }
}
