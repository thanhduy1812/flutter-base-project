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
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
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

class HotelSearchDetailListRoomView extends BaseView<HotelSearchDetailListRoomViewModel> {
  const HotelSearchDetailListRoomView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return _buildListRoomOption(context);
  }

  Widget _buildListRoomOption(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => HotelDraftBookingCubit(),
      child: StatefulBuilder(builder: (context, setState) {
        return Card(
          color: Colors.white,
          elevation: 3,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Opacity(
                      opacity: viewModel.isEmptyRoom ? 0.4 : 1,
                      child: Column(
                        children: [
                          GtdListHorizontalImages(images: viewModel.hotelRoomDetailDTO.images),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: GtdExpansionHeaderView(
                              isExpand: viewModel.isExpand,
                              titleHeader: viewModel.hotelRoomDetailDTO.name,
                              onTapHeader: viewModel.isEmptyRoom
                                  ? null
                                  : () {
                                      setState(
                                        () => viewModel.isExpand = !viewModel.isExpand,
                                      );
                                    },
                              collapsedView: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Wrap(
                                  children: viewModel.hotelRoomDetailDTO.overviewAmenities
                                      .map((e) => GtdAmenityView(
                                            title: e.value,
                                            leadingIcon: GtdAppIcon.iconNamedSupplier(iconName: "hotel/${e.icon}"),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          GtdDashedBorder(
                            strokeWidth: 1,
                            color: Colors.grey.shade200,
                            customPath: (size) => Path()
                              ..moveTo(0, 0)
                              ..lineTo(constraints.maxWidth, 0),
                            child: const SizedBox(
                              width: double.infinity,
                              height: 1,
                            ),
                          ),
                          GtdExpansionView(
                            collapsed: !viewModel.isExpand,
                            duration: const Duration(milliseconds: 400),
                            reverseDuration: const Duration(milliseconds: 400),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.hotelRoomDetailDTO.ratePlans.length,
                              itemBuilder: (context, index) {
                                final HotelSearchRoomViewModel searchRoomViewModel;
                                var parentViewModel = pageContext.viewModelOf();
                                if (parentViewModel is ComboHotelSearchDetailPageViewModel) {
                                  searchRoomViewModel = ComboSearchRoomViewModel.fromRatePlanCombineFlight(
                                      flightSearchResultDTO: parentViewModel.flightSearchResultDTO!,
                                      searchFlightFormModel: parentViewModel.searchFlightFormModel,
                                      searchHotelFormModel: parentViewModel.searchHotelFormModel,  
                                      ratePlan: viewModel.hotelRoomDetailDTO.ratePlans[index],
                                      tripId: viewModel.tripId,
                                      roomId: viewModel.hotelRoomDetailDTO.id)
                                    ..comparePrice = viewModel.comparePrice;
                                } else {
                                  searchRoomViewModel = HotelSearchRoomViewModel.fromRatePlan(
                                      viewModel.hotelRoomDetailDTO.ratePlans[index],
                                      tripId: viewModel.tripId,
                                      roomId: viewModel.hotelRoomDetailDTO.id)
                                    ..comparePrice = viewModel.comparePrice;
                                }
                                return HotelSearchRoomView(
                                  viewModel: searchRoomViewModel,
                                  onSelectHeader: (value) {
                                    GtdHotelSearchAllRateRq? searchAllRateRq =
                                        BlocProvider.of<HotelSearchDetailCubit>(context).searchAllRateRq;
                                    final HotelSearchRoomDetailPageViewModel roomDetailViewModel;
                                    if (parentViewModel is ComboHotelSearchDetailPageViewModel) {
                                      roomDetailViewModel =
                                          ComboSearchRoomDetailPageViewModel.fromRatePlanCombineFlights(
                                              hotelName: viewModel.hotelName,
                                              flightSearchResultDTO: parentViewModel.flightSearchResultDTO!,
                                              searchFlightFormModel: parentViewModel.searchFlightFormModel,
                                              tripId: viewModel.tripId,
                                              ratePlan: value,
                                              hotelRoomDetailDTO: viewModel.hotelRoomDetailDTO);
                                    } else {
                                      roomDetailViewModel = HotelSearchRoomDetailPageViewModel.fromRatePlan(
                                          hotelName: viewModel.hotelName,
                                          tripId: viewModel.tripId,
                                          ratePlan: value,
                                          hotelRoomDetailDTO: viewModel.hotelRoomDetailDTO);
                                    }

                                    roomDetailViewModel.searchAllRateRq = searchAllRateRq;
                                    roomDetailViewModel.comparePrice = viewModel.comparePrice;
                                    context.push(HotelSearchRoomDetailPage.route, extra: roomDetailViewModel);
                                  },
                                );
                              },
                            ),
                          ),
                          viewModel.isExpand ? const Divider() : const SizedBox(),
                          !viewModel.isEmptyRoom ? _buildFooterViewMore(setState) : const SizedBox(),
                        ],
                      ),
                    ),
                    viewModel.isEmptyRoom ? _buildEmptyRoomWarning() : const SizedBox(),
                  ],
                );
              },
            ),
          ),
        );
      }),
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
            Text(viewModel.isExpand ? "Thu gọn" : "Xem thêm ${viewModel.hotelRoomDetailDTO.ratePlans.length} lựa chọn",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Icon(viewModel.isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRoomWarning() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Opacity(
        opacity: 1,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: ListTile(
              horizontalTitleGap: 5,
              leading: ColorFiltered(
                  colorFilter: const ColorFilter.mode(CustomColors.mainRed, BlendMode.srcIn),
                  child: GtdAppIcon.iconNamedSupplier(iconName: "error-circle.svg", height: 24)),
              title: const Text(
                "Rất tiếc! Chúng tôi đã hết phòng cho ngày bạn chọn.",
                style: TextStyle(fontSize: 13, color: CustomColors.mainRed),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
