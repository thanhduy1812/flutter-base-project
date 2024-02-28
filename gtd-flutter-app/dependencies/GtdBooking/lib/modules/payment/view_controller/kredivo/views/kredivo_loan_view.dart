import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_outline_select_button/view/gtd_outline_select_button.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/payment_resource/payment_resource.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

import '../cubit/payment_kredivo_cubit.dart';
import '../view_model/kredivo_load_viewmodel.dart';

class KredivoLoadView extends BaseView<KredivoLoadViewModel> {
  const KredivoLoadView({super.key, required super.viewModel});

  Widget buildHeaderBookingNumber({EdgeInsets? padding}) {
    return Ink(
      color: Colors.white,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Mã tham chiếu",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Expanded(child: SizedBox()),
            Text(
              viewModel.bookingNumber,
              style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const IconButton(
              onPressed: null,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              icon: Icon(
                Icons.content_copy,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentKredivoCubit()..getLoadKredivo(),
      child: BlocBuilder<PaymentKredivoCubit, PaymentKredivoState>(
        builder: (kredivoContext, state) {
          if (state is PaymentKredivoInitial) {
            viewModel.kredivoOtions = BlocProvider.of<PaymentKredivoCubit>(kredivoContext).kredivoOptionVMs;
          }
          var kredivoOptions = viewModel.kredivoOtions;

          if (kredivoOptions.isEmpty) {
            return const SizedBox(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            GtdLoanKredivoMonth selectedKredivoMonth =
                kredivoOptions.where((element) => element.isSelected).firstOrNull?.data ?? kredivoOptions[0].data;
            return Ink(
              color: Colors.grey.shade100,
              child: SizedBox(
                child: Column(
                  children: [
                    buildHeaderBookingNumber(),
                    Expanded(
                      child: CustomScrollView(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Chọn gói trả góp",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.boldText),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                color: Colors.white,
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              var data = kredivoOptions[index];
                                              return GtdSelectItem(
                                                viewModel: data,
                                                centerItem: Center(
                                                  child: Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text: "${data.itemTitle} \n",
                                                          style:
                                                              const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                                      TextSpan(
                                                          text: data.itemSubTitle,
                                                          style:
                                                              const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))
                                                    ]),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                onSelect: (value) {
                                                  if (value.isSelected) {
                                                    kredivoOptions
                                                        .where((element) => element.data != value.data)
                                                        .map((e) => e..isSelected = false)
                                                        .toList();
                                                    selectedKredivoMonth = value.data;
                                                  }
                                                  // BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                                                  BlocProvider.of<PaymentKredivoCubit>(context).updateSelectLoan();
                                                },
                                              );
                                            },
                                            separatorBuilder: (context, index) => const SizedBox(
                                                  width: 8,
                                                ),
                                            itemCount: kredivoOptions.length),
                                      ),
                                      SizedBox(
                                        height: 54,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Góp ${selectedKredivoMonth.key} tháng",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.boldText),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 46,
                                          child: Row(children: [
                                            Text(
                                              "Số tiền thanh toán",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400, fontSize: 15, color: AppColors.subText),
                                            ),
                                            const Spacer(),
                                            Text(
                                              (selectedKredivoMonth.initialAmount ?? 0).toCurrency(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.boldText),
                                            )
                                          ])),
                                      const Divider(),
                                      SizedBox(
                                          height: 46,
                                          child: Row(children: [
                                            Text(
                                              "Phí chuyển đổi (${selectedKredivoMonth.processingFeeRate})",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400, fontSize: 15, color: AppColors.subText),
                                            ),
                                            const Spacer(),
                                            Text(
                                              (selectedKredivoMonth.processingFee ?? 0).toCurrency(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.boldText),
                                            )
                                          ])),
                                      const Divider(),
                                      SizedBox(
                                          height: 46,
                                          child: Row(children: [
                                            Text(
                                              "Góp mỗi tháng",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400, fontSize: 15, color: AppColors.subText),
                                            ),
                                            const Spacer(),
                                            Text(
                                              (selectedKredivoMonth.monthlyInstallment ?? 0).toCurrency(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: AppColors.currencyText),
                                            )
                                          ])),
                                      const Divider(),
                                      SizedBox(
                                          height: 46,
                                          child: Row(children: [
                                            Text(
                                              "Tổng tiền trả góp",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400, fontSize: 15, color: AppColors.subText),
                                            ),
                                            const Spacer(),
                                            Text(
                                              (selectedKredivoMonth.paybackAmount ?? 0).toCurrency(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.boldText),
                                            )
                                          ])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: ListTile(
                                leading: const Icon(Icons.info_sharp),
                                title: Text(
                                  "Đặt chỗ với phương thức thanh toán trả góp sẽ KHÔNG THỂ HỦY và sẽ được chuyển đổi trả góp sau khi thanh toán thành công.",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.boldText),
                                ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 70),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: GtdButton(
                                    isEnable: true,
                                    onPressed: (value) {
                                      context.pop();
                                    },
                                    text: "Xác nhận",
                                    fontSize: 16,
                                    height: 48,
                                    borderRadius: 24,
                                    gradient: AppColors.appGradient,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
