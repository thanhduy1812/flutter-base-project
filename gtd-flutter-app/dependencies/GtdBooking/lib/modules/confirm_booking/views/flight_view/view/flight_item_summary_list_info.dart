import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';

import 'flight_summary_item.dart';
import 'flight_summary_vertical_item.dart';

class FlightItemSummaryListInfo extends StatelessWidget {
  final List<GtdFlightItemDetail> flighItems;
  const FlightItemSummaryListInfo({super.key, required this.flighItems});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      slivers: [buildVerticalListFlightItems(flighItems)],
    );
  }

  static Widget buildHorizontalListFlightItems(List<GtdFlightItemDetail> flighItems, {bool isLoading = false}) {
    return SliverToBoxAdapter(
      child: SizedBox(
          height: 117,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 0),
                itemCount: flighItems.length,
                itemBuilder: (context, index) {
                  double widthItem = flighItems.length == 1 ? constraints.maxWidth - 16 : constraints.maxWidth * 5 / 6;
                  return FlightSummaryItem(
                    viewModel: FlightSummaryItemViewModel.fromItemDetail(flightItemDetail: flighItems[index]),
                    width: widthItem,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 16),
              );
            },
          )),
    );
  }

  // static Widget buildHorizontaFlightInieraries(GtdFlightSearchResultDTO flightSearchResultDTO) {
  //   List<FlightSummaryItemViewModel> itemViemodels =
  //       FlightSummaryItemViewModel.fromGtdFlightSearchResultDTO(flightSearchResultDTO);
  //   return SizedBox(
  //       height: 125,
  //       child: LayoutBuilder(
  //         builder: (context, constraints) {
  //           return ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.only(left: 4, right: 0, top: 4, bottom: 4),
  //             itemCount: itemViemodels.length,
  //             itemBuilder: (context, index) {
  //               double widthItem = itemViemodels.length == 1 ? constraints.maxWidth - 16 : constraints.maxWidth * 5 / 6;
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4),
  //                 child: FlightSummaryItem(
  //                   viewModel: itemViemodels[index],
  //                   width: widthItem,
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       ));
  // }

  static Widget buildHorizontalFlightInieraries(List<FlightSummaryItemViewModel> items) {
    return SizedBox(
        height: 125,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 4, right: 0, top: 4, bottom: 4),
              itemCount: items.length,
              itemBuilder: (context, index) {
                double widthItem = items.length == 1 ? constraints.maxWidth - 16 : constraints.maxWidth * 5 / 6;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FlightSummaryItem(
                    viewModel: items[index],
                    width: widthItem,
                  ),
                );
              },
            );
          },
        ));
  }

  static buildVericalFlightSummaryItems(List<FlightSummaryItemViewModel> itemViewModels) {
    return Column(
      children: itemViewModels
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: FlightSummaryItem(width: double.infinity, viewModel: e),
              ))
          .toList(),
    );
  }

  static Widget buildVerticalListFlightItems(List<GtdFlightItemDetail> flighItems) {
    return SliverList.separated(
      itemCount: flighItems.length,
      itemBuilder: (context, index) {
        return FlightSummaryVerticalItem(
            viewModel: FlightSummaryItemViewModel.fromItemDetail(flightItemDetail: flighItems[index]));
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
