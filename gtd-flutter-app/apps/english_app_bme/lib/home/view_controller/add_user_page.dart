import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view/input_text_field.dart';
import 'package:english_app_bme/home/view_model/add_user_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

class AddUserPage extends BaseStatelessPage<AddUserPageViewModel> {
  static const String route = '/addUser';
  const AddUserPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
          child: Column(
        children: [
          Text(viewModel.headerTitle,
              style: const TextStyle(fontSize: 24, color: appBlueDeepColor, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InputTextField(
                hintText: 'Please input mentor name',
                labelText: "Mentor name",
                leadingIcon: Icon(
                  Icons.person,
                  color: Colors.grey.shade400,
                ),
                onChanged: (value) {}),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InputTextField(
                hintText: '09xxxxxxxx',
                labelText: "Phone Number",
                leadingIcon: Icon(
                  Icons.phone,
                  color: Colors.grey.shade400,
                ),
                onChanged: (value) {}),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InputTextField(
                hintText: 'anthony@gmail.com',
                labelText: "Email",
                leadingIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.grey.shade400,
                ),
                onChanged: (value) {}),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InputTextField(
                hintText: 'Please input address',
                labelText: "Address",
                leadingIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.grey.shade400,
                ),
                onChanged: (value) {}),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GtdButton(
                      text: "Cancel",
                      fontSize: 18,
                      borderRadius: 18,
                      colorText: Colors.red,
                      color: Colors.red.shade50,
                      height: 60,
                      onPressed: (value) {
                        pageContext.pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GtdButton(
                      text: "Confirm",
                      fontSize: 18,
                      borderRadius: 18,
                      colorText: Colors.white,
                      color: Colors.orange,
                      height: 60,
                      onPressed: (value) {
                        pageContext.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
