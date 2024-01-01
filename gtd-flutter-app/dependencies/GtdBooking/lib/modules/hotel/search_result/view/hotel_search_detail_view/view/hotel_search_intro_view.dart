
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/booking_common/view/gtd_expansion_header_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_intro_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';

class HotelSearchIntroView extends BaseView<HotelSearchIntroViewModel> {
  const HotelSearchIntroView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return _buildHotelIntro();
  }

  Widget _buildHotelIntro() {
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
                  titleHeader: "Giới thiệu khách sạn",
                  onTapHeader: () {
                    setState(
                      () => viewModel.isExpand = !viewModel.isExpand,
                    );
                  },
                  collapsedView: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text.rich(
                      TextSpan(
                          text: viewModel.description,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      maxLines: viewModel.isExpand ? 1000 : 4,
                      overflow: TextOverflow.ellipsis,
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
