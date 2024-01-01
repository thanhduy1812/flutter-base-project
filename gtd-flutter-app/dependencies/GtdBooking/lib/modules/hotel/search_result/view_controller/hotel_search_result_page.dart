import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/combo/search_result/view_model/combo_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_filter_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_vertical_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_sort_header_tab_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_result_filter_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_sort_header_tab_viewmode.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../view/hotel_result_map_view.dart';

class HotelSearchResultPage extends BaseStatelessPage<HotelSearchResultPageViewModel> {
  static const String route = '/hotelSearchResultPage';

  const HotelSearchResultPage({super.key, required super.viewModel});

  @override
  List<Widget> buildTrailingActions(BuildContext pageContext) {
    return [
      BlocBuilder<HotelSearchCubit, HotelSearchState>(
        builder: (hotelSearchContext, hotelSearchState) {
          return StreamBuilder(
              stream: BlocProvider.of<HotelSearchCubit>(hotelSearchContext).hotelFilterOptionController.stream,
              builder: (context, snapshot) {
                var filterOptions = snapshot.data ?? [];
                return IconButton(
                    onPressed: () {
                      GtdPresentViewHelper.presentView(
                          title: "Bộ lọc",
                          context: context,
                          contentPadding: const EdgeInsets.all(0),
                          hasInsetBottom: false,
                          builder: Builder(
                            builder: (context) {
                              return HotelResultFilterView(
                                viewModel:
                                    HotelResultFilterViewModel(filterOptions, savedGroupListItems: viewModel.filterVMs),
                                onApplyFilter: (value) {
                                  //Check empty filter
                                  if (value.flattened.where((e) => e.isSelected).map((e) => e.data).toList().isEmpty) {
                                    viewModel.filterVMs = [];
                                  } else {
                                    viewModel.filterVMs = value;
                                  }
                                  print("apply filter here");
                                  //Reset page when apply Filter
                                  BlocProvider.of<HotelSearchCubit>(hotelSearchContext)
                                      .applyFilter(viewModel.createSearchRequest(isRefesh: true));
                                },
                              );
                            },
                          ));
                    },
                    icon: GtdAppIcon.iconNamedSupplier(
                        iconName: viewModel.filterVMs.isEmpty ? "icon-filter.svg" : "icon-filtered.svg"));
              });
        },
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              (viewModel is ComboSearchResultPageViewModel)
                  ? const SizedBox()
                  : ColoredBox(
                      color: Colors.white, child: HotelSortHeaderTabView(viewModel: HotelSortHeaderTabViewModel())),
              Expanded(
                child: BlocBuilder<HotelSearchCubit, HotelSearchState>(
                  builder: (hotelSearchContext, hotelSearchState) {
                    if (hotelSearchState is HotelSearchLoading) {
                      return HotelResultContentVerticalView.hotelContentLoading();
                    }
                    // if (hotelSearchState is HotelSearchLoaded) {
                    //   viewModel.updateHotelResultDTO(hotelSearchState.hotelSearchResultDTO);
                    // }
                    if (hotelSearchState is HotelSortLoaded) {
                      viewModel.updateHotelResultDTO(hotelSearchState.hotelSearchResultDTO);
                    }
                    if (hotelSearchState is HotelSearchLoadmoreLoaded) {
                      // update hotelItems here
                      viewModel.verticalContentViewModel.updateMoreItems(hotelSearchState.hotelSearchResultDTO);
                      viewModel.mapViewModel.updateMoreItems(hotelSearchState.hotelSearchResultDTO);
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: viewModel.viewType == HotelSearchResultViewType.list
                          ? HotelResultContentVerticalView(
                              viewModel: viewModel.verticalContentViewModel,
                              scrollController: viewModel.verticalController,
                            )
                          : HotelResultMapView(viewModel: viewModel.mapViewModel),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: IntrinsicWidth(
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: Card(
                      color: AppColors.mainColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      child: InkWell(
                        onTap: () {
                          setState(
                            () {
                              if (viewModel.viewType == HotelSearchResultViewType.list) {
                                viewModel.viewType = HotelSearchResultViewType.map;
                              } else {
                                viewModel.viewType = HotelSearchResultViewType.list;
                              }
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GtdAppIcon.iconNamedSupplier(
                                    iconName:
                                        "/hotel/${viewModel.viewType == HotelSearchResultViewType.list ? "hotel-icon-map" : "hotel-icon-list"}.svg",
                                    width: 32),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  viewModel.viewType == HotelSearchResultViewType.list ? "Bản đồ" : "Danh sách",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
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
