import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_item_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/payment_method_type.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:shimmer/shimmer.dart';

class PaymentMethodItem extends BaseView<PaymentMethodItemViewModel> {
  final GtdCallback<PaymentMethodType>? onChanged;
  const PaymentMethodItem({super.key, required super.viewModel, this.onChanged});

  @override
  Widget buildWidget(BuildContext context) {
    // var viewModel = context.viewModelOf<PaymentMethodItemViewModel>();
    var paymentType = viewModel.paymentType;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (viewModel.isSelected != true) {
          viewModel.isSelected = !viewModel.isSelected;
          onChanged?.call(paymentType);
        }
      },
      child: SizedBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: viewModel.paymentType.iconImage,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        (paymentType.title.isEmpty)
                            ? const SizedBox()
                            : Text(
                                paymentType.title,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                        (paymentType.desTitle.isEmpty)
                            ? const SizedBox()
                            : Text(
                                paymentType.desTitle,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                        (paymentType.discount.isEmpty)
                            ? const SizedBox()
                            : Card(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                                elevation: 0,
                                color: const Color(0xFFFFF2E9),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    paymentType.discount,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                ),
                              ),
                        (paymentType.subTitle.isEmpty)
                            ? const SizedBox()
                            : Text(
                                paymentType.subTitle,
                                // "abcd",
                                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade700),
                              )
                      ],
                    ),
                  ),
                ),
                // const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    (viewModel.isSelected) ? Icons.radio_button_on_rounded : Icons.radio_button_off,
                    size: 22,
                    color: (viewModel.isSelected) ? Colors.green : Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  static Widget buildLoadingLishtPaymentMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: ListView.separated(
            itemCount: 4,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade50,
                child: const SizedBox(
                  height: 72,
                  child: Card(
                    color: Colors.white,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        ),
      ),
    );
  }
}
