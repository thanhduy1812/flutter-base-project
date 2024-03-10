import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view_model/user_list_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

class UserListView extends BaseView<UserListViewModel> {
  const UserListView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          var user = viewModel.bmeUsers[index];
          return SizedBox(
            // height: 50,
            child: ListTile(
              leading:
                  GtdImage.svgFromAsset(assetPath: "assets/image/ico-contact.svg", color: appBlueDeepColor, width: 32),
              title: Text(user.fullName ?? "--",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.boldText)),
              subtitle: Text(user.phoneNumber ?? "--",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.subText)),
              trailing: Card(
                  elevation: 0,
                  color: appOrangeDarkColor,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(user.role ?? ""),
                  )),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
        itemCount: viewModel.bmeUsers.length);
  }
}
