import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/final_booking_detail_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/final_booking_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/payment/cubit/payment_method_cubit.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

import '../view_model/payment_paylater_page_viewmodel.dart';

class PaymentPaylaterPage extends PricingBottomPage<PaymentPaylaterPageViewModel> {
  static const String route = '/paymentPaylaterPage';
  const PaymentPaylaterPage({super.key, required super.viewModel});

  @override
  Widget buildBottomNext(BuildContext paymentContext) {
    return GtdButton(
      isEnable: true,
      onPressed: (value) {
        // GtdAppLoading.of(paymentContext).show();
        // BlocProvider.of<PaymentMethodCubit>(paymentContext)
        //     .paymentBooking(paymentMethodType: viewModel.paymentMethodType)
        //     .then((value) {
        //   GtdAppLoading.of(paymentContext).hide();
        //   value.when(
        //       (success) => paymentContext.push(BaseWebViewPage.route,
        //           extra: BaseWebViewPageViewModel(url: success)..title = viewModel.paymentMethodType.title),
        //       (error) => GtdPopupMessage(paymentContext).showError(error: error.message));
        // });
        FinalBookingDetailPageViewModel finalBookingDetailPageViewModel =
            FinalBookingDetailPageViewModel(bookingNumber: viewModel.bookingNumber);
        paymentContext.push(FinalBookingDetailPage.route, extra: finalBookingDetailPageViewModel);
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
                              text:
                                  "Quý khách cần thanh toán trước thời hạn cho phép giữ chỗ của hệ thống bằng cách trực tiếp đến địa chỉ văn phòng Gotadi hoặc thực hiện chuyển khoản theo cú pháp được hướng dẫn trong Email xác nhận giữ chỗ.",
                              style: TextStyle(color: AppColors.subText, fontSize: 13, fontWeight: FontWeight.w400)),
                        ]),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text("Địa chỉ văn phòng Gotadi",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                      initiallyExpanded: true,
                      shape: const Border(),
                      children: [
                        Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var officerInfo = viewModel.officerInfos[index];
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      margin: const EdgeInsets.all(0),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(color: CustomColors.borderColor, width: 1.0),
                                          borderRadius: BorderRadius.circular(16)),
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: "${officerInfo.name} \n",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.boldText)),
                                          TextSpan(
                                              text: "${officerInfo.address} \n",
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                                          TextSpan(
                                              text: "${officerInfo.phone} \n",
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                                          TextSpan(
                                              text: "${officerInfo.contact}",
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                                        ])),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                      height: 8,
                                    ),
                                itemCount: viewModel.officerInfos.length),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text("Thông tin ngân hàng nhận chuyển khoản",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                      initiallyExpanded: true,
                      shape: const Border(),
                      children: [
                        Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var bankHolder = viewModel.bankHolders[index];
                                  return InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: bankHolder.accountNumber!));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text("STK copied")));
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        margin: const EdgeInsets.all(0),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(color: CustomColors.borderColor, width: 1.0),
                                            borderRadius: BorderRadius.circular(16)),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 76,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 8),
                                                  child: GtdImage.imgFromCommon(
                                                      assetName: "assets/icons/bank-icon/${bankHolder.bankLogo}"),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text: "${bankHolder.bankName} \n",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColors.boldText)),
                                                  TextSpan(
                                                      text: "${bankHolder.accountName} \n",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: AppColors.subText)),
                                                  TextSpan(
                                                      text: "STK: ${bankHolder.accountNumber}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColors.boldText)),
                                                ])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                      height: 8,
                                    ),
                                itemCount: viewModel.bankHolders.length),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ))
      ],
    );
  }
}
