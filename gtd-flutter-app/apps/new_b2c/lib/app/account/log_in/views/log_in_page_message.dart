import 'package:dvt_helper/dvt_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LogInPageMessage extends StatelessWidget {
  const LogInPageMessage({super.key});

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
