import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/combo/search_result/view_model/combo_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_item_summary_list_info.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/flight_header_expand_view_model.dart';
import 'package:gtd_booking/modules/flight/search_result/views/flight_header_expand_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_controller/hotel_search_result_page.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_result_page_viewmodel.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

class ComboSearchResultPage extends BaseStatelessPage<ComboSearchResultPageViewModel> {
  static const String route = '/comboSearchResultPage';
  const ComboSearchResultPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 1),
                  Builder(
                    builder: (context) {
                      if (viewModel.viewType == HotelSearchResultViewType.map) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          StatefulBuilder(builder: (context, setStateFlightInfo) {
                            return ListenableBuilder(
                              listenable: viewModel.isExpandFlightInfoNotifier,
                              builder: (context, child) {
                                return StreamBuilder(
                                    stream: viewModel.flightSearchSubject.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.data?.isLoaded == false) {
                                        return FlightHeaderExpandView(
                                            viewModel: FlightheaderExpandViewModel(isExpandFlightInfo: true),
                                            isLoading: true);
                                      }
                                      if (snapshot.data?.data != null) {
                                        viewModel.updateFlightSelectedItems(
                                            FlightSummaryItemViewModel.fromGtdFlightSearchResultDTO(
                                                snapshot.data!.data!));
                                        return FlightHeaderExpandView(
                                            viewModel: FlightheaderExpandViewModel.fromFlightSearchResultDTO(
                                                flightSearchResultDTO: snapshot.data!.data!)
                                              ..isExpandFlightInfo = viewModel.isExpandFlightInfoNotifier.value);
                                      }
                                      return const SizedBox();
                                    });
                              },
                            );
                          }),
                          ColoredBox(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-grey.svg"),
                                  ),
                                  Text.rich(TextSpan(
                                      text: "Chọn khách sạn \n",
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                      children: [
                                        TextSpan(
                                            text: "Giá trọn gói 1 khách / tổng đêm",
                                            style: TextStyle(
                                                fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText))
                                      ])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: viewModel.flightSearchSubject.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data?.data != null) {
                            viewModel.updateFlightSelectedItems(
                                FlightSummaryItemViewModel.fromGtdFlightSearchResultDTO(snapshot.data!.data!));
                          }
                          return HotelSearchResultPage(viewModel: viewModel).buildBody(pageContext);
                        }),
                  )
                ],
              ),
              viewModel.viewType == HotelSearchResultViewType.map
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: InkWell(
                          onTap: () {
                            GtdPresentViewHelper.presentSheet(
                                title: "Chuyến bay đề xuất",
                                context: context,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                builder: Builder(
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 48),
                                      child: FlightItemSummaryListInfo.buildVericalFlightSummaryItems(
                                          viewModel.flightSelectedItems),
                                    );
                                  },
                                ));
                          },
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.zero,
                            elevation: 16,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            child: SizedBox(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: GtdAppIcon.iconNamedSupplier(iconName: "flight/plane.svg", height: 32),
                                    ),
                                    const Text(
                                      "Xem chuyến bay đề xuất",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelSearchCubit()
        // ..searchHotelBestRate(viewModel.createSearchRequest())
        ..getHotelFilterOptions(),
      child: super.build(context),
    );
  }
}
