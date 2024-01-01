import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view_model/hotel_summary_item_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';
import 'package:shimmer/shimmer.dart';

class HotelSummaryItem extends BaseView<HotelSummaryItemViewModel> {
  final double? width;
  const HotelSummaryItem({super.key, required super.viewModel, this.width});

  @override
  Widget buildWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        GtdPresentViewHelper.presentView(
            title: "Thông tin khách sạn",
            context: context,
            hasInsetBottom: false,
            useRootContext: true,
            contentPadding: EdgeInsets.zero,
            builder: Builder(
              builder: (context) {
                return const SizedBox();
                // return FlightItemDetailView(
                //     viewModel: FlightItemDetailViewModel(flightItemDetail: viewModel.flightItemDetail!));
              },
            ));
      },
      child: SizedBox(
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFF47920),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Khách sạn đã chọn ",
                        style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        viewModel.changeHotelHeader,
                        style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Ink(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: SizedBox(
                            child: Text(
                              viewModel.titleHeader,
                              style: TextStyle(fontSize: 13, color: AppColors.boldText, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                          child: SizedBox(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    viewModel.roomType,
                                    style:
                                        TextStyle(fontSize: 12, color: AppColors.boldText, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 24,
                                  color: AppColors.mainColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text.rich(TextSpan(
                                    text: "Nhận phòng \n",
                                    style: TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                                    children: [
                                      TextSpan(
                                          text: viewModel.checkin,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: CustomColors.mainOrange))
                                    ])),
                                Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                                          borderRadius: BorderRadius.circular(100)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        child: Text(
                                          "${viewModel.nights} đêm",
                                          style: TextStyle(
                                              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.boldText),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text.rich(
                                  TextSpan(
                                      text: "Trả phòng \n",
                                      style: TextStyle(
                                          fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                                      children: [
                                        TextSpan(
                                            text: viewModel.checkout,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: CustomColors.mainOrange))
                                      ]),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildPreviewtHotelSummaryItem() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 117,
        child: HotelSummaryItem(
          viewModel: HotelSummaryItemViewModel(),
        ),
      ),
    );
  }

  static Widget buildLoadingShimmerHotelItem() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 117,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade50,
          child: const SizedBox(
            width: 300,
            child: Card(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
