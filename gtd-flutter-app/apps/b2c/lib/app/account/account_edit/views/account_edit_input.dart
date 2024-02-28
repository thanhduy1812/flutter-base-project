import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:new_gotadi/app/account/account_edit/account_edit.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AccountEditInput extends StatelessWidget {
  final AccountEditFieldNames fieldName;
  final VoidCallback? onTap;

  const AccountEditInput({
    super.key,
    required this.fieldName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = AbsorbPointer(
      absorbing: onTap != null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: GtdColors.snowGrey),
          ),
        ),
        child: ReactiveTextField(
          formControlName: fieldName.value,
          keyboardType: fieldName.inputType(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(fieldName.typingExpression()),
          ],
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: GtdColors.inkBlack,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: fieldName.title(),
            labelStyle: TextStyle(
              fontSize: 15,
              color: GtdColors.slateGrey,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: onTap != null
                ? SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: GtdImage.svgFromSupplier(
                        assetName: 'assets/icons/drop-down.svg',
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
    if (onTap != null) {
      return GtdTapWidget(
        onTap: onTap ?? () {},
        child: child,
      );
    } else {
      return child;
    }
  }
}
