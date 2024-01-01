import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/booking_common/view/gtd_expansion_header_view.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_item_summary_list_info.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_summary_item.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/flight_header_expand_view_model.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';

class FlightHeaderExpandView extends BaseView<FlightheaderExpandViewModel> {
  final Axis axixDirection;
  final bool isLoading;
  const FlightHeaderExpandView(
      {super.key, required super.viewModel, this.axixDirection = Axis.horizontal, this.isLoading = false});

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setStateFlightInfo) {
      return Column(
        children: [
          ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GtdAppIcon.iconNamedSupplier(iconName: "flight/plane.svg", height: 32),
                  ),
                  Expanded(
                    child: GtdExpansionHeaderView(
                      isExpand: viewModel.isExpandFlightInfo,
                      titleHeader: "Chuyến bay đề xuất",
                      onTapHeader: () {
                        setStateFlightInfo(
                          () {
                            viewModel.isExpandFlightInfo = !viewModel.isExpandFlightInfo;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: viewModel.isExpandFlightInfo
                ? (switch (axixDirection) {
                    Axis.vertical => isLoading
                        ? FlightSummaryItem.buildLoadingWidgetFlightItems()
                        : FlightItemSummaryListInfo.buildVericalFlightSummaryItems(viewModel.flighItems),
                    Axis.horizontal => isLoading
                        ? FlightSummaryItem.buildLoadingWidgetFlightItems()
                        : FlightItemSummaryListInfo.buildHorizontalFlightInieraries(viewModel.flighItems)
                  })
                : const SizedBox(),
          )
        ],
      );
    });
  }
}
