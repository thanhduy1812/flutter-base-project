import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view_model/user_list_viewmodel.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_page.dart';
import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

class UserListView extends BaseView<UserListViewModel> {
  final bool isShowRating;
  const UserListView({super.key, required super.viewModel, this.isShowRating = false});

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
              subtitle: Row(
                children: [
                  isShowRating
                      ? Card(
                          elevation: 0,
                          color: appOrangeDarkColor,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              user.role ?? "",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(width: isShowRating ? 8 : 0),
                  Text(user.phoneNumber ?? "--",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.subText)),
                ],
              ),
              trailing: isShowRating
                  ? viewModel.ratingByUsername(user.username ?? "") != null
                      ? LessonPage.iconRating(viewModel.ratingByUsername(user.username ?? "")!)
                      : const SizedBox()
                  : Card(
                      elevation: 0,
                      color: appOrangeDarkColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          user.role ?? "",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
              onTap: () {
                GtdPresentViewHelper.presentSheet(
                    title: "",
                    context: context,
                    builder: Builder(
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _accountInfo(user),
                        );
                      },
                    ));
              },
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
        itemCount: viewModel.bmeUsers.length);
  }

  Widget _accountInfo(BmeUser user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // CircleAvatar(
        //   radius: 50.0,
        //   backgroundImage: AssetImage('images/profile.jpg'),
        // ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          user.fullName ?? "",
          style: const TextStyle(
            fontFamily: 'DancingScript',
            fontSize: 28.0,
            color: appBlueDeepColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          user.socialName ?? "",
          style: const TextStyle(
            fontFamily: 'SourceSansPro',
            color: appOrangeDarkColor,
            letterSpacing: 5,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 20,
          width: 180,
          child: Divider(
            color: appOrangeDarkColor,
          ),
        ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 60.0,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(
              Icons.call,
              size: 40.0,
              color: appOrangeLightColor,
            ),
            title: const Text(
              'Phone',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'SourceSansPro',
                color: appBlueDeepColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(user.phoneNumber ?? "---"),
          ),
        ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 60.0,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(
              Icons.date_range,
              size: 40.0,
              color: appOrangeDarkColor,
            ),
            title: const Text(
              'BirthDate',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'SourceSansPro',
                color: appBlueDeepColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(user.dob ?? "---"),
          ),
        ),
      ],
    );
  }
}
