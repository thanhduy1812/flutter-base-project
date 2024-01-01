import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../../../view_model/price_bottom_detail_viewmodel.dart';
import '../../price_bottom_detail_view.dart';
import '../view_model/final_booking_status_viewmodel.dart';

class FinalBookingStatusView extends BaseView<FinalBookingStatusViewModel> {
  const FinalBookingStatusView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.zero,
          color: viewModel.finalBookingStatus.statusColor,
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.only(top: 4),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    viewModel.finalBookingStatus.icon,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: viewModel.finalBookingStatus.title,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.boldText),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    viewModel.isWaitingPayment
                        ? Card(
                            elevation: 0,
                            margin: const EdgeInsets.all(8),
                            color: CustomColors.mainOrange.shade50,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text.rich(TextSpan(
                                    text: "Vui lòng thanh toán trước \n",
                                    children: [
                                      TextSpan(
                                          text: viewModel.paymentInfo.paymentDate,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: CustomColors.mainOrange))
                                    ],
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w400, color: CustomColors.mainOrange))),
                              ),
                            ),
                          )
                        : viewModel.finalBookingStatus.additionalInfo
                  ],
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: Colors.white,
            child: GtdDashedBorder(
              color: Colors.grey.shade400,
              padding: const EdgeInsets.all(0),
              dashPattern: const [2, 2],
              customPath: (size) => Path()
                ..moveTo(0, 0)
                ..lineTo(size.width, 0),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      GtdInfoRow(leftText: "Ngày giao dịch", rightText: viewModel.paymentInfo.paymentDate),
                      GtdInfoRow(leftText: "Phương thức", rightText: viewModel.paymentInfo.paymentMethod),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: Colors.white,
            child: GtdDashedBorder(
              color: Colors.grey.shade400,
              padding: const EdgeInsets.all(0),
              dashPattern: const [2, 2],
              customPath: (size) => Path()
                ..moveTo(0, 0)
                ..lineTo(size.width, 0),
              child: SizedBox(
                // height: 100,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      GtdInfoRow(leftText: "Dịch vụ", rightText: viewModel.productInfo.purchaseProduct),
                      InkWell(
                        onTap: () {
                          GtdPresentViewHelper.presentSheet(
                              title: "Chi tiết giá",
                              context: context,
                              isFullScreen: false,
                              builder: Builder(
                                builder: (context) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: PriceBottomDetailView(
                                        viewModel: PriceBottomDetailViewModel.fromBookingDetailDTO(
                                            viewModel.bookingDetailDTO)),
                                  );
                                },
                              ));
                        },
                        child: GtdInfoRow(
                          leftText: "Tổng thanh toán",
                          rightText: viewModel.productInfo.totalPayment,
                          rightColor: AppColors.mainColor,
                          rightIcon: Icon(
                            Icons.keyboard_arrow_right,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
