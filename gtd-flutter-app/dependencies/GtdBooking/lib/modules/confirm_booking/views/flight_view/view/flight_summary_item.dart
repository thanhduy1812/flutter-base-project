import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../view_model/flight_item_detail_viewmodel.dart';
import '../view_model/flight_summary_item_viewmodel.dart';
import 'flight_item_detail_view.dart';

class FlightSummaryItem extends BaseView<FlightSummaryItemViewModel> {
  final double? width;
  final bool showBackBtn;

  const FlightSummaryItem({
    super.key,
    required super.viewModel,
    this.width,
    this.showBackBtn = false,
  });

  @override
  Widget buildWidget(BuildContext context) {
    return InkWell(
      onTap: viewModel.flightItemDetail == null
          ? null
          : () {
              if (showBackBtn) {
                context.pop();
                return;
              }
              GtdPresentViewHelper.presentView(
                title: "Thông tin chuyến bay",
                context: context,
                hasInsetBottom: false,
                useRootContext: true,
                contentPadding: EdgeInsets.zero,
                builder: Builder(
                  builder: (context) {
                    return FlightItemDetailView(
                      viewModel: FlightItemDetailViewModel(
                        flightItemDetail: viewModel.flightItemDetail!,
                      ),
                    );
                  },
                ),
              );
            },
      child: SizedBox(
        width: width ?? 300,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFF47920),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: showBackBtn ? 136 : 117,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _chosenFlightDate(),
                Expanded(
                  child: Ink(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: SizedBox(
                      child: Column(
                        children: [
                          _timeData(),
                          const Divider(),
                          _planeAndClass(context),
                          if (showBackBtn)
                            ...[
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  'Đổi chuyến',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: GtdColors.emerald,
                                  ),
                                ),
                              )
                            ],
                        ],
                      ),
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

  Expanded _planeAndClass(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          child: Row(
            children: [
              SizedBox(
                height: 24,
                child: GtdImage.imgFromUrl(
                  viewModel.airlineLogo,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  viewModel.cabinClass,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (!showBackBtn)
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 24,
                  color: GtdColors.appMainColor(context),
                )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _timeData() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.originCode,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  viewModel.originTime,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  viewModel.transitionTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  viewModel.duration,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  viewModel.destinationCode,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.destinationTime,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (viewModel.difInDays() > 0)
                      Text(
                        '+${viewModel.difInDays()}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _chosenFlightDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${viewModel.titleHeader.tr()} đã chọn",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            viewModel.departDate,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildPreviewListFlightItems() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 117,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16, right: 0),
          itemCount: 2,
          itemBuilder: (context, index) {
            return FlightSummaryItem(
              viewModel: FlightSummaryItemViewModel(),
            );
          },
        ),
      ),
    );
  }

  static Widget buildLoadingShimmerFlightItems() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 117,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16, right: 0),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade50,
              child: const SizedBox(
                width: 300,
                child: Card(
                  color: Colors.white,
                ),
              ),
            );
            // return FlightSummaryItem(
            //   viewModel: FlightSummaryItemViewModel(),
            // );
          },
        ),
      ),
    );
  }

  static Widget buildLoadingWidgetFlightItems() {
    return SizedBox(
      height: 117,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 0),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade50,
            child: const SizedBox(
              width: 300,
              child: Card(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
