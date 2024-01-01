import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/reservation_detail_view/view_model/booking_invoice_info_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';

class BookingInvoiceInfoView extends BaseView<BookingInvoiceInfoViewModel> {
  const BookingInvoiceInfoView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 16),
                  child: Text(
                    "Thông tin Doanh nghiệp",
                    style: TextStyle(fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600),
                  ),
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: ListView.custom(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childrenDelegate: SliverChildListDelegate([
                      GtdInfoRow(
                          leftText: "Tên Doanh nghiệp",
                          rightText: viewModel.companyName,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Mã số thuế",
                          rightText: viewModel.companyTax,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Địa chỉ",
                          rightText: viewModel.companyAddress,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Tỉnh / TP",
                          rightText: viewModel.companyAddressCity,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Quốc gia",
                          rightText: viewModel.companyAddressCountry,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 16),
                  child: Text(
                    "Thông tin người nhận hoá đơn",
                    style: TextStyle(fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600),
                  ),
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: ListView.custom(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childrenDelegate: SliverChildListDelegate([
                      GtdInfoRow(
                          leftText: "Họ & Tên người nhận",
                          rightText: viewModel.receiveName,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Điện thoại",
                          rightText: viewModel.receivePhoneNumber,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Email liên hệ",
                          rightText: viewModel.receiveEmail,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
