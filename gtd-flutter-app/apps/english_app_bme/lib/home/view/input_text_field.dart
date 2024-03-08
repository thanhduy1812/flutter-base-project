import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

class InputTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Widget? leadingIcon;
  final GtdCallback<String> onChanged;
  final focusNode = FocusNode();
  InputTextField({super.key, required this.hintText, this.labelText, this.leadingIcon, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
        floatingLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: appBlueDeepColor),
        hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
        filled: false,
        fillColor: Colors.white,
        focusColor: appBlueDeepColor,
        hoverColor: appBlueDeepColor,
        prefixIcon: leadingIcon,
      ),
      onChanged: (value) => onChanged.call(value),
    );
  }
}
