import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view_controller/home_page.dart';
import 'package:english_app_bme/login/view_model/login_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

class LoginPage extends BaseStatelessPage<LoginPageViewModel> {
  static const String route = '/login';
  const LoginPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
          child: Column(
        children: [
          Center(child: GtdImage.imgFromAsset(assetPath: "assets/icon/beme-logo.png", width: 150)),
          const Text("Welcome", style: TextStyle(fontSize: 24, color: appBlueDeepColor, fontWeight: FontWeight.w700)),
          Text("Login to your account",
              style: TextStyle(fontSize: 20, color: AppColors.subText, fontWeight: FontWeight.w400)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
                hintText: 'Please input your username',
                labelText: "Username",
                hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
                filled: false,
                fillColor: Colors.white,
                focusColor: appBlueDeepColor,
                hoverColor: appBlueDeepColor,
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey.shade500,
                ),
              ),
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
                hintText: 'Please input your password',
                labelText: "Password",
                hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
                filled: false,
                fillColor: Colors.white,
                focusColor: appBlueDeepColor,
                hoverColor: appBlueDeepColor,
                prefixIcon: Icon(
                  Icons.key,
                  color: Colors.grey.shade500,
                ),
              ),
              onChanged: (value) {},
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GtdButton(
                text: "Login",
                fontSize: 20,
                colorText: Colors.white,
                color: Colors.orange,
                height: 60,
                onPressed: (value) {
                  pageContext.pushReplacement(HomePage.route);
                },
              ),
            ),
          )
        ],
      )),
    );
  }
}
