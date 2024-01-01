import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/item_flight_component_viewmodel.dart';
import 'package:gtd_booking/modules/flight/search_result/views/loading/list_flight_item_loading.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_itinerary.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class FlightSearchResultPageViewModel extends BasePageViewModel {
  final GtdFlightSearchResultDTO flightSearchResultDTO;
  final SearchFlightFormModel searchFlightFormModel;
  final List<Widget> loadingItems = [1].map((e) => ListFlightItemLoading.flightItemLoadingWidget()).toList();
  final FlightDirection flightDirection;
  late FilterAvailabilityRq filterAvailabilityRq;
  List<AllFilterOptionsDTO> filterOptions = [];
  // List<GtdFlightItem> flighItems = [];
  List<ItemFlightComponentViewModel> itemFlightViewModels = [];
  GtdFlightItem? selectedFlightItem;
  int currentPage = 0;
  int totalPage = 0;
  // bool hasNextPage = false;
  bool isLastPage = false;
  bool beginLoadMore = false;
  FlightSearchResultPageViewModel(
      {required this.flightSearchResultDTO, required this.flightDirection, required this.searchFlightFormModel}) {
    title = 'flight.searchResult'.tr(gender: flightDirection.value.toLowerCase());

    if (flightDirection == FlightDirection.d) {
      filterAvailabilityRq = flightSearchResultDTO.departureItinerary!.filterOptions!;
    }

    if (flightDirection == FlightDirection.r) {
      String searchId = (flightDirection == FlightDirection.d)
          ? flightSearchResultDTO.departureSearchId!
          : ((isDome) ? flightSearchResultDTO.returnSearchId! : flightSearchResultDTO.departureSearchId!);

      var departureItinerary = flightSearchResultDTO.initDepartureItineraryRq;
      filterAvailabilityRq = FilterAvailabilityRq.createFilterRq(
          searchId: searchId,
          flightDirection: flightDirection,
          flightType: flightSearchResultDTO.flightType!,
          departureItinerary: departureItinerary);
    }
  }
  GtdFlightItinerary? get flightItinerary => flightDirection == FlightDirection.d
      ? flightSearchResultDTO.departureItinerary
      : flightSearchResultDTO.returnItinerary;
  bool get isDome => flightSearchResultDTO.flightType == FlightType.dom;
  bool get isRoundTrip => flightSearchResultDTO.isRoundTrip;

  bool get hideFilter => !isDome && flightDirection == FlightDirection.r;

  FlightType get flightType => flightSearchResultDTO.flightType!;

  ({String title, String subTitle}) get headerFlightTuple {
    String title = "";
    title = (flightDirection == FlightDirection.d)
        ? "${searchFlightFormModel.fromLocation.name} - ${searchFlightFormModel.toLocation.name}"
        : "${searchFlightFormModel.toLocation.name} - ${searchFlightFormModel.fromLocation.name}";
    int totalPassenger = (searchFlightFormModel.adult) + (searchFlightFormModel.child) + (searchFlightFormModel.infant);
    String subTitle =
        "${(flightDirection == FlightDirection.d ? searchFlightFormModel.departDate : searchFlightFormModel.returnDate)?.localDate('EEEE dd/MM/yyyy')} - $totalPassenger hành khách";
    return (title: title, subTitle: subTitle);
  }

  void updateFlightSearchResultDTO() {
    flightItinerary?.flightItems = itemFlightViewModels.map((e) => e.groupItem).toList();
  }

  void updateFlightItems(GtdFlightSearchResultDTO flightSearchResultDTO) {
    var newItinerary = flightDirection == FlightDirection.d
        ? flightSearchResultDTO.departureItinerary
        : flightSearchResultDTO.returnItinerary;
    //Update itinerary if first load
    if (flightItinerary == null) {
      switch (flightDirection) {
        case FlightDirection.d:
          this.flightSearchResultDTO.departureItinerary = newItinerary;
          break;
        case FlightDirection.r:
          this.flightSearchResultDTO.returnItinerary = newItinerary;
          break;
        default:
      }
    }
    currentPage = newItinerary?.page?.pageNumber ?? 0;
    isLastPage = newItinerary?.page?.isLastPage ?? true;
    var newItems = (newItinerary?.flightItems ?? [])
        .map((e) => ItemFlightComponentViewModel(groupItem: e, groupItemSelected: selectedFlightItem))
        .toList();
    itemFlightViewModels.addAll(newItems);
  }

  void refresh() {
    filterAvailabilityRq.page = 0;
    currentPage = 0;
    itemFlightViewModels = [];
    isLastPage = false;
  }

  void updateFilterLoadMore() {
    if (isLastPage == false) {
      filterAvailabilityRq.page = currentPage + 1;
    }
  }

  void applyFilter(List<AllFilterOptionsDTO> filterOptions) {
    refresh();
    filterAvailabilityRq.filter =
        FlightFilter.toGtdFilterOptions(flightItinerary?.filterOptions, filterOptions, flightDirection);
  }

  void addLoadingItems() {
    List<ItemFlightComponentViewModel> flightLoadingItems =
        Iterable<int>.generate(4).map((e) => ItemFlightComponentViewModel.loading()).toList();
    itemFlightViewModels.addAll(flightLoadingItems);
    beginLoadMore = true;
  }

  void finishLoadingItems() {
    itemFlightViewModels.removeWhere((element) => element.viewType == ItemFlightType.loading);
    beginLoadMore = false;
  }

  GtdFlightDraftBookingRq get draftBookingRq {
    GtdFlightDraftBookingRq draftBookingRq = flightSearchResultDTO.createDraftBookingRq();
    return draftBookingRq;
  }
}
