import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/payment/cubit/payment_method_cubit.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_list_viewmodel.dart';
import 'package:gtd_booking/modules/payment/views/payment_method_item.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/utils/popup/gtd_app_loading.dart';

class PaymentMethodListView extends BaseView<PaymentMethodListViewModel> {
  const PaymentMethodListView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
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
            itemCount: viewModel.paymentItems.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return PaymentMethodItem(
                viewModel: viewModel.paymentItems[index],
                onChanged: (value) {
                  if (viewModel.paymentItems[index].isSelected) {
                    viewModel.paymentItems
                        .whereNot((element) => element.paymentType == viewModel.paymentItems[index].paymentType)
                        .map((e) => e.isSelected = false)
                        .toList();
                    GtdAppLoading.of(context).show();
                    BlocProvider.of<PaymentMethodCubit>(context).paymentFee(paymentType: value).then((value) {
                      GtdAppLoading.of(context).hide();
                      BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                    });
                  }
                  BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                },
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
