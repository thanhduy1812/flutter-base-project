import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/checkout/view_model/gtd_display_price_item_vm.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_detail_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

class PriceBottomDetailView extends BaseView<PriceBottomDetailViewModel> {
  const PriceBottomDetailView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    if (viewModel.supplier == GtdAppSupplier.vib) {
      return _buildVIBBottomPrices();
    } else {
      return _buildGotadiBottomPriceView();
    }
  }

  Widget _buildVIBBottomPrices() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ListView.builder(
        itemCount: viewModel.items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var itemPrice = viewModel.items[index];
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        itemPrice.shortTitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: itemPrice.subTitle.isEmpty
                              ? Colors.grey.shade500
                              : Colors.grey.shade900,
                        ),
                      ),
                      subtitle: itemPrice.subTitle.isEmpty
                          ? null
                          : Text(
                              itemPrice.subTitle,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    itemPrice.price.toCurrency(),
                    textAlign: TextAlign.start,
                    style: itemPrice.type == GtdDisplayItemType.totalPrice
                        ? TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          )
                        : TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900,
                          ),
                  ),
                ],
              ),
              const Divider(
                height: 1,
                color: Color(0xFFF3F4F6),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGotadiBottomPriceView() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Builder(
            builder: (context) {
              return viewModel.headerVM == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.headerVM?.shortTitle ?? "",
                            style: TextStyle(
                              color: AppColors.boldText,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            viewModel.headerVM?.subTitle ?? "",
                            style: TextStyle(
                              color: AppColors.subText,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    );
            },
          ),
          Column(
            children: viewModel.items
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          e.shortTitle,
                          style: TextStyle(
                            color: AppColors.subText,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // e.type.icon,
                        const Spacer(),
                        Text(
                          e.price.toCurrency(),
                          style: TextStyle(
                            color: AppColors.boldText,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          Divider(
            thickness: 3,
            color: Colors.grey.shade200,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.totalPriceVM.shortTitle,
                      style: TextStyle(
                        color: AppColors.boldText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      viewModel.totalPriceVM.subTitle,
                      style: TextStyle(
                        color: AppColors.subText,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  viewModel.totalPriceVM.price.toCurrency(),
                  style: TextStyle(
                    color: AppColors.currencyText,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
