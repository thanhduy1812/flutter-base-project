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
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_draft_booking_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_detail_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/combo_search_room_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/reponse/gtd_hotel_search_all_rates_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_all_rate_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_amenity_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tool_tip_shape/gtd_custom_tooltip.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../view_model/hotel_search_room_viewmodel.dart';

class HotelSearchRoomView extends BaseView<HotelSearchRoomViewModel> {
  final GtdCallback<RatePlan>? onSelectHeader;

  const HotelSearchRoomView(
      {super.key, required super.viewModel, this.onSelectHeader});

  @override
  Widget buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
        child: Column(
          children: [
            _refundPolicy(),
            const SizedBox(height: 8),
            if (viewModel.ratePlan.amenities?.isNotEmpty == true)
              _amenitiesList(),
            _roomDetailsBtn(),
            Divider(
              thickness: 1,
              height: 1,
              color: GtdColors.snowGrey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
                bottom: 20,
                top: 16,
              ),
              child: Column(
                children: [
                  _noOfRoomLeft(),
                  _price(),
                  const SizedBox(height: 12),
                  _buttons(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buttons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GtdButton(
            text: "Tạm tính",
            height: 40,
            color: Colors.white,
            colorText: AppColors.normalText,
            leadingIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GtdAppIcon.iconNamedSupplier(
                iconName: "icon-info-blue.svg",
                color: Colors.grey.shade800,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            border: Border.fromBorderSide(
              BorderSide(
                color: Colors.grey.shade200,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            borderRadius: 20,
            onPressed: (value) {
              GtdPresentViewHelper.presentSheet(
                title: "Tổng tạm tính",
                context: context,
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
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildCheckoutButton(context),
        ),
      ],
    );
  }

  Widget _price() {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              '${viewModel.priceTitle}',
              style: TextStyle(
                fontSize: 12,
                color: GtdColors.slateGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Spacer(),
            viewModel.hasPromo && viewModel.ratePlan.basePriceBeforePromo != 0
                ? Text(
                    viewModel.totalRoomPricePerNight,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.lineThrough,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.strikeText,
                    ),
                  )
                : const SizedBox(),
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
    );
  }

  Row _noOfRoomLeft() {
    return Row(
      children: [
        GtdAppIcon.iconNamedSupplier(
          iconName: "hotel/hotel-room-warning.svg",
          height: 20,
        ),
        Text(
          " Chỉ còn ${viewModel.ratePlan.totalRooms ?? 0} phòng giá này",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.currencyText,
          ),
        ),
      ],
    );
  }

  Padding _roomDetailsBtn() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        height: 40,
        child: InkWell(
          onTap: () {
            onSelectHeader?.call(viewModel.ratePlan);
          },
          child: GtdInfoRow.seperatedRow(
            title: Text(
              "Chi tiết phòng",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.mainColor,
                fontSize: 13,
              ),
            ),
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  SizedBox _amenitiesList() {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) => GtdAmenityView(
          title: viewModel.ratePlan.amenities?[index].name ?? "",
        ),
        itemCount: (viewModel.ratePlan.amenities ?? []).length,
      ),
    );
  }

  Container _refundPolicy() {
    final penaltyData = viewModel.ratePlan.cancelPenaltiesData();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          // if (viewModel.ratePlan.cancelFree != true &&
          //     viewModel.ratePlan.refundable != true)
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

  Widget _buildCheckoutButton(BuildContext context) {
    if (viewModel is ComboSearchRoomViewModel) {
      return BlocProvider(
        create: (context) => ComboDraftBookingCubit(),
        child: BlocBuilder<ComboDraftBookingCubit, ComboDraftBookingState>(
          builder: (draftBookingContext, draftBookingState) {
            return GtdButton(
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.grey.shade200, width: 1)),
              height: 40,
              borderRadius: 20,
              color: AppColors.mainColor,
              text: "Chọn phòng",
              onPressed: (value) {
                GtdLoading.show();
                BlocProvider.of<ComboDraftBookingCubit>(draftBookingContext)
                    .draftBookingCombo((viewModel as ComboSearchRoomViewModel)
                        .createDraftBookingComboRq)
                    .then((value) {
                  GtdLoading.hide();
                  value.when((success) {
                    GtdHotelSearchAllRateRq? searchAllRateRq =
                        BlocProvider.of<HotelSearchDetailCubit>(context)
                            .searchAllRateRq;
                    ComboCheckoutPageViewModel checkoutViewModel =
                        ComboCheckoutPageViewModel(
                            bookingDetailDTO: success,
                            searchAllRateRq: searchAllRateRq!,
                            searchFlightFormModel:
                                (viewModel as ComboSearchRoomViewModel)
                                    .searchFlightFormModel);
                    context.push(ComboCheckoutPage.route,
                        extra: checkoutViewModel);
                  }, (error) {
                    GtdPopupMessage(context).showError(error: error.message);
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
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.grey.shade200, width: 1)),
              height: 40,
              borderRadius: 20,
              color: AppColors.mainColor,
              text: "Chọn phòng",
              onPressed: (value) {
                GtdLoading.show();
                BlocProvider.of<HotelDraftBookingCubit>(draftBookingContext)
                    .draftBookingHotel(viewModel.createCheckoutRq())
                    .then((value) {
                  GtdLoading.hide();
                  value.when((success) {
                    GtdHotelSearchAllRateRq? searchAllRateRq =
                        BlocProvider.of<HotelSearchDetailCubit>(context)
                            .searchAllRateRq;
                    HotelCheckoutPageViewModel checkoutViewModel =
                        HotelCheckoutPageViewModel(
                            bookingDetailDTO: success,
                            searchAllRateRq: searchAllRateRq!);
                    context.push(HotelCheckoutPage.route,
                        extra: checkoutViewModel);
                  }, (error) {
                    GtdPopupMessage(context).showError(error: error.message);
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
