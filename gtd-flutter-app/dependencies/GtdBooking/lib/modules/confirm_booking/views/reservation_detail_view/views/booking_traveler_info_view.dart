import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/reservation_detail_view/view_model/booking_traveler_info_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';

class BookingTravelerInfoView extends BaseView<BookingTravelerInfoViewModel> {
  const BookingTravelerInfoView({super.key, required super.viewModel});

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
                    "Thông tin liên hệ",
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
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          viewModel.title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Họ",
                          rightText: viewModel.lastName,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Tên đệm & Tên",
                          rightText: viewModel.firstName,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Giới tính",
                          rightText: viewModel.gender,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Ngày sinh",
                          rightText: viewModel.dob,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Quốc tịch",
                          rightText: viewModel.country,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Thông tin Passport",
                          rightText: viewModel.passportNumber,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Quốc gia cấp",
                          rightText: viewModel.nationality,
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
                    "Tài khoản khách hàng thân thiết",
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
                          leftText: "Loại tài khoản",
                          rightText: viewModel.frequentFlyerType,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Số thẻ",
                          rightText: viewModel.frequentFlyerNumber,
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
                    "Hành lý & suất ăn",
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
                          leftText: "Hành lý miễn phí",
                          rightText: viewModel.baggageFreeInfo,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Hành lý ký gửi",
                          rightText: viewModel.baggagePurchaseInfo,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                      const Divider(),
                      GtdInfoRow(
                          leftText: "Suất ăn",
                          rightText: viewModel.mealInfo,
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
