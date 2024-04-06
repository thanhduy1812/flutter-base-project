import 'package:easy_localization/easy_localization.dart';
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
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_amenity_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dots_paging_listview/gtd_image_page_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_image_gallery_viewer.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tool_tip_shape/gtd_custom_tooltip.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../view_model/hotel_search_room_detail_page_viewmodel.dart';

class HotelSearchRoomDetailPage
    extends BaseStatelessPage<HotelSearchRoomDetailPageViewModel> {
  static const String route = '/hotelSearchRoomDetailPage';

  const HotelSearchRoomDetailPage({super.key, required super.viewModel});

  @override
  List<Widget> buildTrailingActions(BuildContext pageContext) {
    return [
      IconButton(
        onPressed: () {},
        icon: SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: GtdImage.svgFromSupplier(
              assetName: 'assets/icons/share.svg',
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return CustomScrollView(
      slivers: [
        _roomImages(),
        _nameAndOverview(),
        _refundAndAmenities(),
        _priceData(),
      ],
    );
  }

  SliverToBoxAdapter _priceData() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GtdAppIcon.iconNamedSupplier(
                      iconName: "hotel/hotel-room-warning.svg",
                      height: 20,
                    ),
                    Text(
                      " chỉ còn ${viewModel.ratePlan.totalRooms ?? 0} phòng",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.currencyText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      viewModel.comparePrice != null
                          ? "Giá chênh lệch / 1 khách / tổng đêm"
                          : "1 phòng/1 đêm",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.subText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (viewModel.ratePlan.hasPromo)
                      Text(
                        viewModel.totalRoomPricePerNight,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.strikeText,
                        ),
                      ),
                    if (viewModel.ratePlan.hasPromo)
                      const SizedBox(
                        width: 8,
                      ),
                    Text(
                      viewModel.netRoomPricePerNight,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.currencyText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _roomImages() {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pageController = PageController();
          return SizedBox(
            width: double.infinity,
            height: constraints.maxWidth / 2,
            child: GtdImagePageView(
              images: viewModel.hotelRoomDetailDTO.images,
              pageController: pageController,
              onImageTap: (index) {
                GtdImageGalleryViewer().showGalleryImages(
                  images: viewModel.hotelRoomDetailDTO.images,
                  currentIndex: index,
                  context: context,
                );
              },
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _nameAndOverview() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.hotelRoomDetailDTO.name,
                style: TextStyle(
                  fontSize: 17,
                  color: GtdColors.inkBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                children: viewModel.hotelRoomDetailDTO.overviewAmenities
                    .map((e) => GtdAmenityView(
                          title: e.value,
                          leadingIcon: GtdAppIcon.iconNamedSupplier(
                            iconName: "hotel/${e.icon}",
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _refundAndAmenities() {
    return SliverToBoxAdapter(
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _refundPolicy(),
              const SizedBox(height: 8),
              Wrap(
                children: (viewModel.ratePlan.amenities ?? [])
                    .map((e) => e.name)
                    .whereType<String>()
                    .map((e) => GtdAmenityView(title: e))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _refundPolicy() {
    final penaltyData = viewModel.ratePlan.cancelPenaltiesData();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            viewModel.ratePlan.cancelPolicyTitle.title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: CustomColors.darkBlue,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          if (viewModel.ratePlan.cancelFree != true &&
              viewModel.ratePlan.refundable != true)
            GtdCustomTooltip.tooltipWidget(
              backgroundColor: GtdColors.steelGrey,
              contentWidget: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: GtdColors.steelGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'hotel.cancelPenalties.title'.tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'hotel.cancelPenalties.description'.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        color: GtdColors.stormGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (penaltyData.cancelStart != null &&
                        penaltyData.cancelEnd != null) ...[
                      _TooltipDataLine(
                        title: 'hotel.cancelPenalties.cancelRoomDate'.tr(args: [
                          penaltyData.cancelStart ?? '',
                          penaltyData.cancelEnd ?? '',
                        ]),
                        data: 'hotel.cancelPenalties.losePercent'.tr(args: [
                          penaltyData.loseAmount ?? '100%',
                        ]),
                      ),
                      const SizedBox(height: 8),
                    ],
                    _TooltipDataLine(
                      title: 'hotel.cancelPenalties.noShow'.tr(),
                      data: 'hotel.cancelPenalties.loseAll'.tr(),
                    ),
                  ],
                ),
              ),
              tooltipWidget: Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: GtdAppIcon.iconNamedSupplier(
                      iconName: "icon-info-blue.svg",
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
                          return PriceBottomDetailView(
                            viewModel: viewModel.priceBottomDetailViewModel,
                          );
                        },
                      ),
                    );
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
                    .draftBookingCombo(
                        (viewModel as ComboSearchRoomDetailPageViewModel)
                            .createDraftBookingComboRq)
                    .then((value) {
                  GtdLoading.hide();
                  value.when((success) {
                    ComboCheckoutPageViewModel checkoutViewModel =
                        ComboCheckoutPageViewModel(
                            bookingDetailDTO: success,
                            searchAllRateRq: viewModel.searchAllRateRq!,
                            searchFlightFormModel: (viewModel
                                    as ComboSearchRoomDetailPageViewModel)
                                .searchFlightFormModel);
                    draftBookingContext.push(ComboCheckoutPage.route,
                        extra: checkoutViewModel);
                  }, (error) {
                    GtdPopupMessage(draftBookingContext)
                        .showError(error: error.message);
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
                    HotelCheckoutPageViewModel checkoutViewModel =
                        HotelCheckoutPageViewModel(
                            bookingDetailDTO: success,
                            searchAllRateRq: viewModel.searchAllRateRq!);
                    draftBookingContext.push(HotelCheckoutPage.route,
                        extra: checkoutViewModel);
                  }, (error) {
                    GtdPopupMessage(draftBookingContext)
                        .showError(error: error.message);
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

class _TooltipDataLine extends StatelessWidget {
  final String title;
  final String data;

  const _TooltipDataLine({
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
