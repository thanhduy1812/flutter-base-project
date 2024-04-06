import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:new_gotadi/app/account/register/view_model/register_phone_section_view_model.dart';

class RegisterPhoneSection extends BaseView<RegisterPhoneSectionViewModel> {
  const RegisterPhoneSection({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return const Text('phone_section');
  }
}
