import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';

class LogInPageMessage extends StatelessWidget {
  const LogInPageMessage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'account.logInPageMessage'.tr(),
          style: TextStyle(
            fontSize: 16,
            color: GtdColors.inkBlack,
          ),
        ),
      ),
    );
  }
}
