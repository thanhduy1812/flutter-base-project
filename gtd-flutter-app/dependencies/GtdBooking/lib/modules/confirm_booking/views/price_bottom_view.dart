import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

class PriceBottomView extends BaseView<PriceBottomViewModel> {
  final GtdCallback? onTab;

  const PriceBottomView({super.key, required super.viewModel, this.onTab});

  @override
  Widget buildWidget(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTab?.call("price"),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: viewModel.priceTitle,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        TextSpan(
                          text: '\n${viewModel.priceSubtitle}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                        child: GtdAppIcon.iconNamedSupplier(
                          iconName: "icon-info-blue.svg",
                          color: GtdColors.appMainColor(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: viewModel.netPrice,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.currencyText,
                              ),
                            ),
                            if (viewModel.totalPrice.isNotEmpty)
                              TextSpan(
                                text: '\n${viewModel.totalPrice}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.strikeText,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColors.strikeText,
                                ),
                              ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(vertical: 0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Expanded(
          //           flex: 1,
          //           child: GtdButton(
          //             text: "Thanh toan",
          //             fontSize: 15,
          //             height: 50,
          //             borderRadius: 25,
          //             isEnable: false,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
