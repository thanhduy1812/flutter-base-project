import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_booking/modules/payment/cubit/payment_method_cubit.dart';
import 'package:gtd_booking/modules/payment/view_controller/debit/view_model/debit_bank_item_viewmodel.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/page/base_web_view_page.dart';
import 'package:gtd_utils/base/view_model/base_web_view_page_view_model.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/popup/gtd_app_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

import '../view_model/payment_debit_page_viewmodel.dart';

class PaymentDebitPage extends PricingBottomPage<PaymentDebitPageViewModel> {
  static const String route = '/paymentDebitPage';
  const PaymentDebitPage({super.key, required super.viewModel});

  @override
  Widget buildBottomNext(BuildContext paymentContext) {
    return GtdButton(
      isEnable: viewModel.selectedBank == null ? false : true,
      onPressed: (value) {
        GtdAppLoading.of(paymentContext).show();
        BlocProvider.of<PaymentMethodCubit>(paymentContext)
            .paymentBooking(paymentMethodType: viewModel.paymentMethodType)
            .then((value) {
          GtdAppLoading.of(paymentContext).hide();
          value.when(
              (success) => paymentContext.push(BaseWebViewPage.route,
                  extra: BaseWebViewPageViewModel(url: success)..title = viewModel.paymentMethodType.title),
              (error) => GtdPopupMessage(paymentContext).showError(error: error.message));
        });
      },
      text: "Đi tiếp",
      fontSize: 16,
      height: 48,
      borderRadius: 24,
      gradient: AppColors.appGradient,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (paymentMethodContext) => PaymentMethodCubit(viewModel),
            lazy: false,
          ),
        ],
        child: BlocConsumer<PaymentMethodCubit, PaymentMethodState>(
          listener: (context, state) {
            if (state is PaymentMethodLoadError) {
              GtdPopupMessage(context).showError(error: state.errorMessege);
            }
          },
          builder: (context, state) {
            return super.build(context);
          },
        ));
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return Column(
      children: [
        SizedBox(width: double.infinity, child: buildHeaderBookingNumber(context: pageContext)),
        Expanded(child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: "Chọn ngân hàng thanh toán \n",
                              style: TextStyle(color: AppColors.boldText, fontSize: 15, fontWeight: FontWeight.w600)),
                          TextSpan(
                              text:
                                  "Quý khách sẽ được chuyển tiếp đến cổng thanh toán Ngân lượng để thực hiện thanh toán, sau khi chọn ngân hàng \n",
                              style: TextStyle(color: AppColors.subText, fontSize: 13, fontWeight: FontWeight.w400)),
                          TextSpan(
                              text: "Tài khoản ngân hàng thực hiện giao dịch, cần có đăng ký internet banking.",
                              style: TextStyle(color: AppColors.subText, fontSize: 13, fontWeight: FontWeight.w400)),
                        ]),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.bankDebitOptions.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: constraints.maxWidth / 3,
                              mainAxisExtent: 64,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 11,
                              childAspectRatio: 1.0),
                          itemBuilder: (context, index) {
                            DebitBankItemVM bankModel = viewModel.bankDebitOptions[index];
                            return SizedBox(
                              child: InkWell(
                                onTap: () {
                                  if (bankModel.isSelected == false) {
                                    viewModel.bankDebitOptions.map((e) => e..isSelected = false).toList();
                                    bankModel.isSelected = true;
                                    BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                                  }
                                },
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.0,
                                          color: bankModel.isSelected ? AppColors.mainColor : CustomColors.borderColor),
                                      borderRadius: BorderRadius.circular(16)),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: GtdImage.imgFromCommon(
                                        assetName: "assets/icons/bank-icon/${bankModel.data.logo}",
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ))
      ],
    );
  }
}
