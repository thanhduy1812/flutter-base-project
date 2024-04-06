import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/booking_common/view/gtd_expansion_header_view.dart';
import 'package:gtd_booking/modules/combo/search_result/view_model/combo_hotel_search_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_draft_booking_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_detail_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/combo_search_room_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/combo_search_room_detail_page_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_list_horizontal_images/gtd_list_horizontal_images.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_all_rate_rq.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_amenity_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_expansion_view/gtd_expansion_view.dart';

import '../../../view_controller/hotel_search_room_detail_page.dart';
import '../../../view_model/hotel_search_room_detail_page_viewmodel.dart';
import '../view_model/hotel_search_detail_list_room_viewmodel.dart';
import '../view_model/hotel_search_room_viewmodel.dart';
import 'hotel_search_room_view.dart';

class HotelSearchDetailListRoomView
    extends BaseView<HotelSearchDetailListRoomViewModel> {
  const HotelSearchDetailListRoomView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return _buildListRoomOption(context);
  }

  Widget _buildListRoomOption(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => HotelDraftBookingCubit(),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Card(
            color: Colors.white,
            elevation: 3,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Opacity(
                    opacity: viewModel.isEmptyRoom ? 0.4 : 1,
                    child: Column(
                      children: [
                        GtdListHorizontalImages(
                          images: viewModel.hotelRoomDetailDTO.images,
                        ),
                        _roomNameHeader(setState),
                        _dashLine(constraints),
                        _roomList(pageContext),
                        viewModel.shouldHaveExpand
                            ? _buildFooterViewMore(setState)
                            : const SizedBox(),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  GtdExpansionView _roomList(BuildContext pageContext) {
    return GtdExpansionView(
      collapsed: !viewModel.isExpand,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewModel.hotelRoomDetailDTO.ratePlans.length,
        itemBuilder: (context, index) {
          final price =
              viewModel.hotelRoomDetailDTO.ratePlans[index].totalPrice ?? 0;

          if (price <= 0) {
            return _buildEmptyRoomWarning();
          }

          final HotelSearchRoomViewModel searchRoomViewModel;
          var parentViewModel = pageContext.viewModelOf();
          if (parentViewModel is ComboHotelSearchDetailPageViewModel) {
            searchRoomViewModel =
                ComboSearchRoomViewModel.fromRatePlanCombineFlight(
              flightSearchResultDTO: parentViewModel.flightSearchResultDTO!,
              searchFlightFormModel: parentViewModel.searchFlightFormModel,
              searchHotelFormModel: parentViewModel.searchHotelFormModel,
              ratePlan: viewModel.hotelRoomDetailDTO.ratePlans[index],
              tripId: viewModel.tripId,
              roomId: viewModel.hotelRoomDetailDTO.id,
            )..comparePrice = viewModel.comparePrice;
          } else {
            searchRoomViewModel = HotelSearchRoomViewModel.fromRatePlan(
              viewModel.hotelRoomDetailDTO.ratePlans[index],
              tripId: viewModel.tripId,
              roomId: viewModel.hotelRoomDetailDTO.id,
            )..comparePrice = viewModel.comparePrice;
          }
          return HotelSearchRoomView(
            viewModel: searchRoomViewModel,
            onSelectHeader: (value) {
              GtdHotelSearchAllRateRq? searchAllRateRq =
                  BlocProvider.of<HotelSearchDetailCubit>(context)
                      .searchAllRateRq;
              final HotelSearchRoomDetailPageViewModel roomDetailViewModel;
              if (parentViewModel is ComboHotelSearchDetailPageViewModel) {
                roomDetailViewModel = ComboSearchRoomDetailPageViewModel
                    .fromRatePlanCombineFlights(
                  hotelName: viewModel.hotelName,
                  flightSearchResultDTO: parentViewModel.flightSearchResultDTO!,
                  searchFlightFormModel: parentViewModel.searchFlightFormModel,
                  tripId: viewModel.tripId,
                  ratePlan: value,
                  hotelRoomDetailDTO: viewModel.hotelRoomDetailDTO,
                );
              } else {
                roomDetailViewModel =
                    HotelSearchRoomDetailPageViewModel.fromRatePlan(
                  hotelName: viewModel.hotelName,
                  tripId: viewModel.tripId,
                  ratePlan: value,
                  hotelRoomDetailDTO: viewModel.hotelRoomDetailDTO,
                );
              }

              roomDetailViewModel.searchAllRateRq = searchAllRateRq;
              roomDetailViewModel.comparePrice = viewModel.comparePrice;
              context.push(
                HotelSearchRoomDetailPage.route,
                extra: roomDetailViewModel,
              );
            },
          );
        },
      ),
    );
  }

  GtdDashedBorder _dashLine(BoxConstraints constraints) {
    return GtdDashedBorder(
      strokeWidth: 1,
      color: Colors.grey.shade200,
      customPath: (size) => Path()
        ..moveTo(0, 0)
        ..lineTo(constraints.maxWidth, 0),
      child: const SizedBox(
        width: double.infinity,
        height: 1,
      ),
    );
  }

  Padding _roomNameHeader(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GtdExpansionHeaderView(
        isExpand: viewModel.isExpand,
        titleHeader: viewModel.hotelRoomDetailDTO.name,
        showExpandIcon: false,
        onTapHeader: viewModel.isEmptyRoom
            ? null
            : () {
                setState(
                  () => viewModel.isExpand = !viewModel.isExpand,
                );
              },
        collapsedView: Opacity(
          opacity: viewModel.available ? 1 : 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Wrap(
              children: viewModel.hotelRoomDetailDTO.overviewAmenities
                  .map((e) => GtdAmenityView(
                        title: e.value,
                        leadingIcon: GtdAppIcon.iconNamedSupplier(
                          iconName: "hotel/${e.icon}",
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  InkWell _buildFooterViewMore(StateSetter setState) {
    return InkWell(
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
            Text(
              viewModel.isExpand
                  ? "Thu gọn"
                  : "Xem thêm ${viewModel.hotelRoomDetailDTO.ratePlans.length} "
                      "lựa chọn",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              viewModel.isExpand
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRoomWarning() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        color: Colors.red.shade50,
        child: SizedBox(
          height: 60,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  GtdAppIcon.iconNamedSupplier(
                    iconName: "hotel/hotel-room-sad.svg",
                    height: 24,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      "Chúng tôi không đủ phòng vào thời gian bạn đã chọn!",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
