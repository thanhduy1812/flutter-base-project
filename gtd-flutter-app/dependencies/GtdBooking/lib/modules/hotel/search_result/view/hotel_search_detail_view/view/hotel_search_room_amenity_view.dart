import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/booking_common/view/gtd_expansion_header_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_room_amenity_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_amenity_view.dart';

class HotelSearchRoomAmenityView extends BaseView<HotelSearchRoomAmenityViewModel> {
  const HotelSearchRoomAmenityView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return _buildListAmenities();
  }

  Widget _buildListAmenities() {
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
                  titleHeader: "Tiện ích dịch vụ nơi lưu trú",
                  onTapHeader: () {
                    setState(
                      () => viewModel.isExpand = !viewModel.isExpand,
                    );
                  },
                  collapsedView: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Wrap(
                      children: viewModel.amenityTitles
                          .map((e) => GtdAmenityView(title: e))
                          .take(viewModel.isExpand ? viewModel.amenityTitles.length : 4)
                          .toList(),
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
                      Text(viewModel.isExpand ? "Thu gọn" : "Xem thêm tất cả tiện nghi",
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
