import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:new_gotadi/app/account/account_edit/account_edit.dart';
import 'package:new_gotadi/app/account/account_main/account_main.dart';

class AccountUserWidget extends BaseView<AccountUserViewModel> {
  const AccountUserWidget({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      child: Row(
        children: [
          UserCircularAvatar(
            avatarImage: viewModel.avatarUrl,
          ),
          const SizedBox(width: 12),
          _info(),
          const Spacer(),
          _editBtn(context)
        ],
      ),
    );
  }

  Widget _editBtn(BuildContext context) {
    return GtdTapWidget(
      onTap: () {
        context.push(AccountEditPage.route);
      },
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: GtdImage.svgFromSupplier(
            assetName: 'assets/icons/edit-green.svg',
          ),
        ),
      ),
    );
  }

  Column _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.fullName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'account.membershipClass'.tr(
            args: [
              viewModel.membershipClass,
            ],
          ),
          style: TextStyle(
            fontSize: 14,
            color: GtdColors.steelGrey,
          ),
        ),
      ],
    );
  }
}

///Circular image with border and size
class UserCircularAvatar extends StatelessWidget {
  final double avatarSize;
  final String avatarImage;

  const UserCircularAvatar({
    this.avatarSize = 64,
    required this.avatarImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(avatarSize / 2),
        border: Border.all(
          color: GtdColors.cloudyGrey,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: Visibility(
          visible: avatarImage.isNotEmpty,
          replacement: _avatarErrorWidget(),
          child: Image.memory(base64Decode(avatarImage)),
        ),
      ),
    );
  }

  ///Showing the placeholder image
  _avatarErrorWidget() {
    return GtdImage.imgFromSupplier(
      assetName: 'assets/images/avatar_placeholder.png',
    );
  }
}
