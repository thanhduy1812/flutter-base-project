import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/booking_common/view/gtd_expansion_header_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_policy_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';

class HotelSearchPolicyView extends BaseView<HotelSearchPolicyViewModel> {
  const HotelSearchPolicyView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return _buildHotelPolicy();
  }

  Widget _buildHotelPolicy() {
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: GtdExpansionHeaderView(
                  isExpand: viewModel.isExpand,
                  titleHeader: "Chính sách khách sạn",
                  onTapHeader: () {
                    setState(
                      () => viewModel.isExpand = !viewModel.isExpand,
                    );
                  },
                  collapsedView: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Ink(
                          // color: Colors.white,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade200, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            gradient: AppColors.boxGreyGradient,
                          ),
                          // elevation: 1,
                          // margin: const EdgeInsets.symmetric(vertical: 8),
                          // shape: RoundedRectangleBorder(
                          //     side: BorderSide(color: Colors.grey.shade200, width: 1),
                          //     borderRadius: BorderRadius.circular(8)),
                          child: SizedBox(
                            // height: 57,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IntrinsicWidth(
                                  child: ListTile(
                                    title: Text(
                                      "Nhận phòng",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                                    ),
                                    subtitle: Text(
                                      viewModel.checkin,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                                    ),
                                  ),
                                ),
                                IntrinsicWidth(
                                  child: ListTile(
                                    title: Text(
                                      "Trả phòng",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                                    ),
                                    subtitle: Text(
                                      viewModel.checkout,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                              text: viewModel.policy,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                          maxLines: viewModel.isExpand ? 1000 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              !viewModel.isExpand ? const Divider() : const SizedBox(),
              InkWell(
                onTap: () {
                  setState(
                    () => viewModel.isExpand = !viewModel.isExpand,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(viewModel.isExpand ? "Thu gọn" : "Đọc thêm",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      Icon(viewModel.isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
