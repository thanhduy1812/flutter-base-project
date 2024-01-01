import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/view_controller/flight_checkout_page.dart';
import 'package:gtd_booking/modules/checkout/view_model/flight_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_filter_options_cubit.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_search_cubit.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_search_state.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_select_item_cubit.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_select_item_state.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/flight_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/search_result/views/flight_filter_component.dart';
import 'package:gtd_booking/modules/flight/search_result/views/flight_header_info.dart';
import 'package:gtd_booking/modules/flight/search_result/views/flight_sort_component.dart';
import 'package:gtd_booking/modules/flight/search_result/views/item_flight_component.dart';
import 'package:gtd_booking/modules/flight/search_result/views/loading/list_flight_item_loading.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/helpers/extension/loadmore_list_extention.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

class FlightSearchResultPage extends BaseStatelessPage<FlightSearchResultPageViewModel> {
  static const String route = '/flightSearchResult';

  const FlightSearchResultPage({super.key, required super.viewModel});

  @override
  List<Widget> buildTrailingActions(BuildContext pageContext) {
    if (viewModel.hideFilter) {
      return [];
    }
    var filterOptionCubit = BlocProvider.of<FlightFilterOptionsCubit>(pageContext);
    return <Widget>[
      IconButton(
        splashRadius: 20,
        padding: EdgeInsets.zero,
        onPressed: () => showModalBottomSheet<bool>(
          useRootNavigator: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(38.0),
            ),
          ),
          context: pageContext,
          builder: (BuildContext context) {
            List<AllFilterOptionsDTO> filterOptions = filterOptionCubit.filterSubject.value;
            return FractionallySizedBox(
              heightFactor: 0.92,
              child: FlightFilterResult(
                allFilterOptionsDTO: filterOptions,
                whenDismiss: (valueAction) {
                  filterOptionCubit.applyFilter(valueAction);
                },
              ),
            );
          },
          isScrollControlled: true,
        ).then((isAppliedFilter) {
          if (isAppliedFilter == true) {
            List<AllFilterOptionsDTO> filterOptions = filterOptionCubit.filterSubject.value;
            viewModel.applyFilter(filterOptions);
            BlocProvider.of<FlightSearchCubit>(pageContext)
                .filterAvailabilityWithPaging(viewModel.filterAvailabilityRq, viewModel.flightDirection);
          }
        }),
        icon: GtdImage.svgFromSupplier(assetName: "assets/icons/filter.svg"),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FlightSelectItemCubit(viewModel.flightType)),
        BlocProvider(create: (context) {
          var cubit = (viewModel.isDome) ? FlightSearchDomCubit() : FlightSearchInteCubit();
          return cubit
            ..filterAvailabilityWithPaging(viewModel.filterAvailabilityRq, viewModel.flightDirection)
            ..initFlightSearchResultDTO(viewModel.flightSearchResultDTO)
            ..initFlightFormSearch(viewModel.searchFlightFormModel);
        }),
        BlocProvider(
          create: (context) => FlightFilterOptionsCubit()..getFilterOptions(viewModel.filterAvailabilityRq),
          lazy: false,
        ),
      ],
      child: BlocListener<FlightSearchCubit, FlightSearchState>(
        listener: (flightSearchContext, flightSearchState) {
          if (flightSearchState is FlightSearchErrorState) {
            GtdLoading.hide();
            GtdPopupMessage.showConfirm(
              error: flightSearchState.apiError.message,
              context: flightSearchContext,
            );
          }
          if (flightSearchState is FlightSearchLoadedState) {
            GtdLoading.hide();
            viewModel.updateFlightItems(flightSearchState.flightSearchResultDTO);
          }
          if (flightSearchState is FlightSearchRefeshState) {
            viewModel.updateFlightItems(flightSearchState.flightSearchResultDTO);
          }
          // if (flightSearchState is FlightSearchLoadMoreState) {
          //   viewModel.updateFlightItems(flightSearchState.flightSearchResultDTO);
          // }
        },
        child: BlocBuilder<FlightSearchCubit, FlightSearchState>(
          buildWhen: (previous, current) => current is FlightSearchLoadStatusState,
          builder: (flightSearchContext, flightSearchState) {
            return BlocBuilder<FlightFilterOptionsCubit, FlightFilterOptionsState>(
              builder: (contextFilter, state) {
                return super.build(contextFilter);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<FlightSearchCubit, FlightSearchState>(
      builder: (flightSearchContext, flightSearchState) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.grey.shade50, height: 1),
                SizedBox(
                    height: 72,
                    child: FlightHeaderInfo(
                      title: viewModel.headerFlightTuple.title,
                      subTitle: viewModel.headerFlightTuple.subTitle,
                    )),
                Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ]),
                    child: FlightSortComponent(flightDirection: viewModel.flightDirection)),
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 17, bottom: 14),
                  child: Text("Giá vé đã bao gồm thuế, phí",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey.shade500)),
                ),
                Expanded(
                  child: (flightSearchState is FlightSearchLoadingState)
                      ? const ListFlightItemLoading(
                          itemNumber: 5,
                        )
                      : BlocBuilder<FlightSelectItemCubit, FlightSelectItemState>(
                          builder: (selectItemContext, selectItemState) {
                            viewModel.selectedFlightItem = selectItemState.flightItem;
                            return RefreshIndicator(
                              onRefresh: () => _pullRefresh(flightSearchContext),
                              child: GtdLoadMoreExtention(
                                hasMore: () => !viewModel.isLastPage,
                                itemCount: () => viewModel.itemFlightViewModels.length,
                                loadMore: () async {
                                  if (flightSearchState is! FlightSearchLoadingState) {
                                    viewModel.updateFilterLoadMore();
                                    await BlocProvider.of<FlightSearchCubit>(flightSearchContext)
                                        .loadMoreFlights(viewModel.filterAvailabilityRq, viewModel.flightDirection);
                                  }
                                },
                                onLoadMore: () {
                                  viewModel.addLoadingItems();
                                },
                                onLoadMoreFinished: () {
                                  viewModel.finishLoadingItems();
                                },
                                itemBuilder: (context, index) {
                                  return ItemFlightComponent(
                                    viewModel: viewModel.itemFlightViewModels[index]
                                      ..groupItemSelected = viewModel.selectedFlightItem,
                                    onTab: (value) {
                                      BlocProvider.of<FlightSelectItemCubit>(context).fetchCabinClass(
                                          viewModel.filterAvailabilityRq, value!, viewModel.flightDirection);
                                    },
                                    onPressed: (value) {
                                      viewModel.updateFlightSearchResultDTO();
                                      GtdFlightSearchResultDTO flightSearchResultDTO = viewModel.flightSearchResultDTO;
                                      if (viewModel.isRoundTrip == true &&
                                          viewModel.flightDirection == FlightDirection.d) {
                                        FlightSearchResultPageViewModel returnViewModel =
                                            FlightSearchResultPageViewModel(
                                                flightSearchResultDTO: flightSearchResultDTO,
                                                flightDirection: FlightDirection.r,
                                                searchFlightFormModel: viewModel.searchFlightFormModel);
                                        context.push(
                                          FlightSearchResultPage.route,
                                          extra: returnViewModel,
                                        );
                                      } else {
                                        GtdLoading.show();
                                        BlocProvider.of<FlightSearchCubit>(context).draftBooking(viewModel.draftBookingRq).then((value) {
                                          GtdLoading.hide();
                                          value.when((success) {
                                            var checkoutViewModel = FlightCheckoutPageViewModel(
                                                bookingDetailDTO: success,
                                                searchFlightFormModel: viewModel.searchFlightFormModel);
                                            context.push(FlightCheckoutPage.route, extra: checkoutViewModel);
                                          }, (error) {
                                            GtdLoading.hide();
                                            GtdPopupMessage(context).showError(error: error.message);
                                          });
                                        });
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pullRefresh(BuildContext flightSearchContext) async {
    viewModel.refresh();
    BlocProvider.of<FlightSearchCubit>(flightSearchContext)
        .refreshPage(viewModel.filterAvailabilityRq, viewModel.flightDirection);
  }
}
