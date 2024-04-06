import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/payment/views/promotions/view_model/list_voucher_viewmodel.dart';
import 'package:gtd_booking/modules/payment/views/promotions/views/voucher_item.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

class ListVoucherView extends BaseView<ListVoucherViewModel> {
  const ListVoucherView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => RebuildWidgetCubit(),
      child: Ink(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Ink(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                      hintText: 'Nhập mã khuyến mãi...',
                      hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    onChanged: (value) {
                      viewModel.querySearchController.sink.add(value);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<RebuildWidgetCubit, RebuildWidgetState>(
                builder: (rebuildContext, rebuildState) {
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList.separated(
                          itemCount: viewModel.voucherVMs.length,
                          itemBuilder: (context, index) {
                            return VoucherItem(
                              viewModel: viewModel.voucherVMs[index],
                              onSelected: (value) {
                                viewModel.voucherVMs
                                    .where((element) => element != value)
                                    .map((e) => e..isSelected = false)
                                    .toList();
                                BlocProvider.of<RebuildWidgetCubit>(rebuildContext).rebuildWidget();
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 16,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              // height: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text("Free phí xuất vé, thanh toán qua ví Zalo Pay - 35,000 VND",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.currencyText)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: SizedBox(
                width: double.infinity,
                child: GtdButton(
                  isEnable: true,
                  onPressed: (value) {},
                  text: "Áp dụng",
                  fontSize: 16,
                  height: 48,
                  borderRadius: 24,
                  gradient: AppColors.appGradient,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
