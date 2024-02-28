import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/view_model/combo_result_card_item_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_list_horizontal_images/gtd_list_horizontal_images.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_rating_bar.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../model/hotel_result_card_item_model.dart';
import '../view_model/hotel_result_card_item_viewmodel.dart';

class HotelResultCardItemView extends BaseView<HotelResultCardItemViewModel> {
  // final HotelResultCardItemType viewType;
  final GtdCallback<HotelResultCardItemModel>? onSelect;
  final Function(bool)? onVisibilityChanged;

  const HotelResultCardItemView({
    super.key,
    required super.viewModel,
    this.onSelect,
    this.onVisibilityChanged,
  });

  @override
  Widget buildWidget(BuildContext context) {
    if (viewModel.cardItemType == HotelResultCardItemType.vertical) {
      return _buildVerticalCardItem(context);
    }
    if (viewModel.cardItemType == HotelResultCardItemType.horizontal) {
      return _buildHorizontalCardItem(context);
    }
    if (viewModel.cardItemType == HotelResultCardItemType.loading) {
      return hotelResultCardLoading();
    }
    return _buildVerticalCardItem(context);
  }

  Widget _buildHorizontalCardItem(BuildContext context) {
    return VisibilityDetector(
      key: Key(viewModel.hotelItemModel.propertyId),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction == 1;
        onVisibilityChanged?.call(visible);
      },
      child: InkWell(
        onTap: () {
          if (viewModel is ComboResultCardItemViewModel &&
              (viewModel as ComboResultCardItemViewModel).flightPricePerPerson == 0) {
          } else {
            onSelect?.call(viewModel.hotelItemModel);
          }
        },
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            // height: 159,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _hotelImage(),
                Expanded(
                  child: Column(
                    children: [
                      _buildHotelHeaderGroup(showRatingGrade: false),
                      const Divider(),
                      if (viewModel.hotelItemModel.available) ...[
                        _noOfRoomLeft(),
                        _priceTitle(),
                        _hotelPrice(),
                      ] else
                        buildHotelEmptyRoomWarning(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _hotelPrice() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          const Spacer(),
          viewModel.hotelItemModel.hasPromo
              ? Text(
                  viewModel.totalPrice.toCurrency(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.strikeText,
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              viewModel.netPrice.toCurrency(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.currencyText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _priceTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          viewModel.priceTitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.subText,
          ),
        ),
      ),
    );
  }

  Padding _noOfRoomLeft() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          GtdAppIcon.iconNamedSupplier(
            iconName: "hotel/hotel-room-warning.svg",
            height: 20,
          ),
          Text(
            " ${viewModel.hotelItemModel.hotelRoomNumberWarning}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.currencyText,
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect _hotelImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: SizedBox(
        height: double.infinity,
        width: 80,
        child: GtdImage.cachedImgUrlWithPlaceholder(
          url: viewModel.hotelItemModel.hotelImages.firstOrNull ?? "",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVerticalCardItem(BuildContext context) {
    return InkWell(
      onTap: () {
        if (viewModel is ComboResultCardItemViewModel &&
            (viewModel as ComboResultCardItemViewModel).flightPricePerPerson == 0) {
        } else {
          onSelect?.call(viewModel.hotelItemModel);
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        color: Colors.white,
        child: SizedBox(
          // height: 354,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              //Horizontal Images
              _buildHorizontalHotelImages(),
              // Hotel Title
              _buildHotelHeaderGroup(),
              _buildHotelPolicyAttachments(),
              _buildHotelAmentities(),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              !viewModel.hotelItemModel.available ? buildHotelEmptyRoomWarning() : _buildHotelPricing(),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildHotelPricing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                " ${viewModel.hotelItemModel.hotelRoomNumberWarning}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.currencyText,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Text(
                viewModel.priceTitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subText,
                ),
              ),
            ],
          ),
          viewModel.hotelItemModel.hasPromo
              ? Row(
                  children: [
                    const Spacer(),
                    if (viewModel.hotelItemModel.discountPercent().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: GtdColors.crimsonRed,
                        ),
                        child: Text(
                          viewModel.hotelItemModel.discountPercent(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Builder(
                      builder: (context) {
                        if (viewModel is ComboResultCardItemViewModel &&
                            (viewModel as ComboResultCardItemViewModel).flightPricePerPerson == 0) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade50,
                            child: const SizedBox(
                              width: 150,
                              height: 30,
                              child: Card(
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return Text(
                            viewModel.totalPrice.toCurrency(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.strikeText,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )
              : const SizedBox(),
          Row(
            children: [
              const Spacer(),
              Builder(
                builder: (context) {
                  if (viewModel is ComboResultCardItemViewModel &&
                      (viewModel as ComboResultCardItemViewModel).flightPricePerPerson == 0) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade50,
                      child: const SizedBox(
                        width: 150,
                        height: 30,
                        child: Card(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return Text(
                      viewModel.netPrice.toCurrency(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.currencyText,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildHotelEmptyRoomWarning() {
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildHotelAmentities() {
    if (viewModel.hotelItemModel.hotelAmentites.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Card(
          // margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(
              width: 1,
              color: Colors.grey.shade100,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Center(
              child: Text(
                viewModel.hotelItemModel.hotelAmentites[index],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          width: 0,
        ),
        itemCount: viewModel.hotelItemModel.hotelAmentites.length,
      ),
    );
  }

  Padding _buildHotelPolicyAttachments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
          children: viewModel.hotelItemModel.hotelAttachments
              .map(
                (e) => Card(
                  elevation: 0,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
              .toList()),
    );
  }

  Padding _buildHotelHeaderGroup({bool showRatingGrade = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.hotelItemModel.hotelName.trim(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.grey.shade900,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  viewModel.hotelItemModel.hotelType,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.grey.shade900,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              GtdRatingBar.ratingWithValue(
                viewModel.hotelItemModel.ratingValue,
                itemSize: 16,
              ),
              Text(
                " ${viewModel.hotelItemModel.ratingValue.compactFormat()}/5"
                "${showRatingGrade ? " Tốt" : ""}",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: CustomColors.mainOrange,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: GtdAppIcon.iconNamedSupplier(
                    iconName: "hotel/hotel-search-location.svg",
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  viewModel.hotelItemModel.hotelAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.subText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalHotelImages() {
    return GtdListHorizontalImages(
      images: viewModel.hotelItemModel.hotelImages,
    );
  }

  static Widget hotelResultCardLoading() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: Colors.white,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            //Horizontal Images
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: GtdShimmer(
                      child: SizedBox(
                        width: 270,
                        child: GtdShimmer.cardLoading(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  width: 8,
                ),
                itemCount: 2,
              ),
            ),
            // Hotel Title

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: GtdShimmer(
                child: SizedBox(
                  height: 60,
                  width: 200,
                  child: GtdShimmer.cardLoading(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GtdShimmer(
                child: SizedBox(
                  height: 52,
                  width: 120,
                  child: GtdShimmer.cardLoading(),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GtdShimmer(
                    child: SizedBox(
                      height: 20,
                      width: 150,
                      child: GtdShimmer.cardLoading(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Spacer(),
                      GtdShimmer(
                        child: SizedBox(
                          height: 40,
                          width: 200,
                          child: GtdShimmer.cardLoading(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
