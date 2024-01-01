import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/payment/views/promotions/view_model/voucher_item_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';

class VoucherItem extends BaseView<VoucherItemViewModel> {
  final GtdCallback<VoucherItemViewModel>? onSelected;
  const VoucherItem({super.key, required super.viewModel, this.onSelected});

  @override
  Widget buildWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        viewModel.toggle();
        onSelected?.call(viewModel);
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        child: SizedBox(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 76,
                        child: GtdAppIcon.iconNamedSupplier(iconName: "voucher-zalo.png"),
                      ),
                    ),
                    // const VerticalDivider(color: Colors.amber),
                    Expanded(
                      child: GtdDashedBorder(
                        color: Colors.grey.shade200,
                        dashPattern: const [5, 3],
                        customPath: (size) => Path()
                          ..moveTo(0, 0)
                          ..lineTo(0, size.height),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              (!viewModel.hasLimited)
                                  ? const SizedBox()
                                  : Card(
                                      margin: EdgeInsets.zero,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(6))),
                                      elevation: 0,
                                      color: Colors.deepOrange.shade50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          "Số lượng có hạn",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.normalText),
                                        ),
                                      ),
                                    ),
                              const Text(
                                "Free phí xuất vé, thanh toán qua ví Zalo pay",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              (!viewModel.isNearExpired)
                                  ? const SizedBox()
                                  : Card(
                                      margin: EdgeInsets.zero,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(6))),
                                      elevation: 0,
                                      color: Colors.red.shade50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          "Sắp hết hạn",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 13, color: Colors.red.shade500),
                                        ),
                                      ),
                                    ),
                              Text(
                                "HSD 01.08.2023",
                                // "abcd",
                                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade700),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 16),
                      child: Column(
                        children: [
                          (viewModel.isSelected) ? GtdAppIcon.radioCheckboxActive : GtdAppIcon.radioCheckbox,
                          const SizedBox(
                            height: 8,
                          ),
                          GtdAppIcon.iconNamedSupplier(iconName: "icon-info-outline.svg")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
