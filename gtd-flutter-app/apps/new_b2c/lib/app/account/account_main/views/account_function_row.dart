import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_widgets/gtd_tap_widget.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:new_b2c/app/account/account_main/view_model/account_page_function_view_model.dart';

class AccountFunctionRow extends BaseView<AccountPageFunctionViewModel> {
  final VoidCallback onTap;

  const AccountFunctionRow({
    super.key,
    required super.viewModel,
    required this.onTap,
  });

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: viewModel.marginBottom ? 2 : 0),
      child: GtdTapWidget(
        backgroundColor: Colors.white,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: GtdImage.svgFromSupplier(
                    assetName: viewModel.assetName,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                viewModel.title,
                style: TextStyle(
                  color: GtdColors.inkBlack,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
