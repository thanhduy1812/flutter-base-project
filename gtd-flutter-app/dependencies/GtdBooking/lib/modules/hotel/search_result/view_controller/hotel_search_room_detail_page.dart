import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/view_controller/combo_checkout_page.dart';
import 'package:gtd_booking/modules/checkout/view_controller/hotel_checkout_page.dart';
import 'package:gtd_booking/modules/checkout/view_model/combo_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/hotel_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/combo/cubit/combo_draft_booking_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/views/price_bottom_detail_view.dart';
import 'package:gtd_booking/modules/confirm_booking/views/price_bottom_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_draft_booking_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/combo_search_room_detail_page_viewmodel.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_amenity_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dots_paging_listview/gtd_dots_paging_listview.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tool_tip_shape/gtd_tool_tip_shape.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../view_model/hotel_search_room_detail_page_viewmodel.dart';

class HotelSearchRoomDetailPage extends BaseStatelessPage<HotelSearchRoomDetailPageViewModel> {
  static const String route = '/hotelSearchRoomDetailPage';
  const HotelSearchRoomDetailPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: double.infinity,
                height: constraints.maxWidth / 2,
                child: GtdDotsPagingListView(
                    builder: (index) {
                      return SizedBox(
                        child: GtdImage.cachedImgUrlWithPlaceholder(
                            url: viewModel.hotelRoomDetailDTO.images[index], fit: BoxFit.cover),
                      );
                    },
                    itemCount: viewModel.hotelRoomDetailDTO.images.length),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.hotelRoomDetailDTO.name,
                      style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.boldText, fontSize: 15),
                    ),
                    ListTile(
                      leading: GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-room-loading.svg"),
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Text(
                        viewModel.ratePlan.cancelPolicyTitle.title,
                        style: const TextStyle(fontWeight: FontWeight.w400, color: CustomColors.darkBlue, fontSize: 12),
                      ),
                      trailing: Tooltip(
                        message: viewModel.ratePlan.cancelPolicyTitle.description,
                        verticalOffset: 10,
                        preferBelow: false,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        textStyle: const TextStyle(color: Colors.black),
                        showDuration: const Duration(seconds: 5),
                        decoration: const ShapeDecoration(shape: GtdTooltipShape(), color: Colors.white, shadows: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ]),
                        triggerMode: TooltipTriggerMode.tap,
                        child: GtdAppIcon.iconNamedSupplier(iconName: "icon-info-blue.svg"),
                      ),
                    ),
                    Wrap(
                      children: viewModel.hotelRoomDetailDTO.overviewAmenities
                          .map((e) => GtdAmenityView(
                                title: e.value,
                                leadingIcon: GtdAppIcon.iconNamedSupplier(iconName: "hotel/${e.icon}"),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-room-warning.svg", height: 20),
                        Text(" chỉ còn ${viewModel.ratePlan.totalRooms ?? 0} phòng",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.currencyText)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          viewModel.comparePrice != null
                              ? "Giá chênh lệch / 1 khách / tổng đêm"
                              : "Mỗi phòng / mỗi đêm",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Spacer(),
                        viewModel.ratePlan.hasPromo
                            ? Text(
                                viewModel.totalRoomPricePerNight,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.lineThrough,
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.strikeText),
                              )
                            : const SizedBox(),
                        viewModel.ratePlan.hasPromo
                            ? const SizedBox(
                                width: 8,
                              )
                            : const SizedBox(),
                        Text(viewModel.netRoomPricePerNight,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.currencyText))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tiện ích phòng",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                      children: (viewModel.ratePlan.amenities ?? [])
                          .map((e) => e.name)
                          .whereType<String>()
                          .map((e) => GtdAmenityView(title: e))
                          .toList())
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget? buildBottomBar(BuildContext pageContext) {
    return SafeArea(
      bottom: true,
      child: Ink(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SizedBox(
            height: 130,
            child: Column(
              children: [
                PriceBottomView(
                  viewModel: viewModel.priceBottomViewModel,
                  onTab: (value) {
                    GtdPresentViewHelper.presentSheet(
                        title: "Tổng tạm tính",
                        context: pageContext,
                        builder: Builder(
                          builder: (context) {
                            return PriceBottomDetailView(viewModel: viewModel.priceBottomDetailViewModel);
                          },
                        ));
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildBottomButton(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    if (viewModel is ComboSearchRoomDetailPageViewModel) {
      return BlocProvider(
        create: (context) => ComboDraftBookingCubit(),
        child: BlocBuilder<ComboDraftBookingCubit, ComboDraftBookingState>(
          builder: (draftBookingContext, draftBookingState) {
            return GtdButton(
              text: "Chọn phòng này",
              color: AppColors.mainColor,
              height: 50,
              borderRadius: 25,
              onPressed: (value) {
                GtdLoading.show();
                BlocProvider.of<ComboDraftBookingCubit>(draftBookingContext)
                    .draftBookingCombo((viewModel as ComboSearchRoomDetailPageViewModel).createDraftBookingComboRq)
                    .then((value) {
                  GtdLoading.hide();
                  value.when((success) {
                    ComboCheckoutPageViewModel checkoutViewModel = ComboCheckoutPageViewModel(
                        bookingDetailDTO: success,
                        searchAllRateRq: viewModel.searchAllRateRq!,
                        searchFlightFormModel: (viewModel as ComboSearchRoomDetailPageViewModel).searchFlightFormModel);
                    draftBookingContext.push(ComboCheckoutPage.route, extra: checkoutViewModel);
                  }, (error) {
                    GtdPopupMessage(draftBookingContext).showError(error: error.message);
                  });
                });
              },
            );
          },
        ),
      );
    } else {
      return BlocProvider(
        create: (context) => HotelDraftBookingCubit(),
        child: BlocBuilder<HotelDraftBookingCubit, HotelDraftBookingState>(
          builder: (draftBookingContext, draftBookingState) {
            return GtdButton(
              text: "Chọn phòng này",
              color: AppColors.mainColor,
              height: 50,
              borderRadius: 25,
              onPressed: (value) {
                GtdLoading.show();
                BlocProvider.of<HotelDraftBookingCubit>(draftBookingContext)
                    .draftBookingHotel(viewModel.createCheckoutRq())
                    .then((value) {
                  GtdLoading.hide();
                  value.when((success) {
                    HotelCheckoutPageViewModel checkoutViewModel = HotelCheckoutPageViewModel(
                        bookingDetailDTO: success, searchAllRateRq: viewModel.searchAllRateRq!);
                    draftBookingContext.push(HotelCheckoutPage.route, extra: checkoutViewModel);
                  }, (error) {
                    GtdPopupMessage(draftBookingContext).showError(error: error.message);
                  });
                });
              },
            );
          },
        ),
      );
    }
  }
}
