import 'package:collection/collection.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/app_repository/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';

import '../../../gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'gtd_flight_search_result_dto.dart';


class GtdFlightItinerary {
  GtdFlightItinerary({
    this.page,
    this.flightDirection,
    this.flightItems,
    this.filterOptions,
  });
  Page? page;
  FlightDirection? flightDirection;
  List<GtdFlightItem>? flightItems;
  FilterAvailabilityRq? filterOptions;

  factory GtdFlightItinerary.fromGtdFlightLowSearchRs(
      GtdFlightLowSearchRs result, FilterAvailabilityRq? filterOptions, FlightDirection flightDirection) {
    List<GtdFlightItem> items = result.groupPricedItineraries
            ?.map((e) => e)
            .map((e) => GtdFlightItem.fromGroupPricedItinerary(e, flightDirection))
            .toList() ??
        [];
    filterOptions?.filter = FlightFilter(
        cabinClassOptions: filterOptions.filter?.cabinClassOptions,
        ticketPolicyOptions: filterOptions.filter?.ticketPolicyOptions,
        airlineOptions: filterOptions.filter?.airlineOptions,
        stopOptions: filterOptions.filter?.stopOptions,
        step: filterOptions.filter?.step ?? '1',
        departureDateTimeOptions: filterOptions.filter?.departureDateTimeOptions,
        arrivalDateTimeReturnOptions: filterOptions.filter?.arrivalDateTimeReturnOptions,
        arrivalDateTimeOptions: filterOptions.filter?.arrivalDateTimeOptions,
        priceItineraryId: filterOptions.filter?.priceItineraryId,
        loadMore: filterOptions.filter?.loadMore ?? true,
        departureDateTimeReturnOptions: filterOptions.filter?.departureDateTimeReturnOptions,
        filterFromPrice: filterOptions.filter?.filterFromPrice,
        filterToPrice: filterOptions.filter?.filterToPrice,
        groupId: result.groupPricedItineraries?.firstOrNull?.groupId,
        flightType: result.flightType);

    GtdFlightItinerary flightItinerary = GtdFlightItinerary(
        page: result.page, flightDirection: flightDirection, flightItems: items, filterOptions: filterOptions);
    return flightItinerary;
  }

  factory GtdFlightItinerary.fromGroupPricedItinerary(
      GroupPricedItinerary result, FilterAvailabilityRq? filterOptions, FlightDirection flightDirection) {
    List<GtdFlightItem> items =
        [result].map((e) => e).map((e) => GtdFlightItem.fromGroupPricedItinerary(e, flightDirection)).toList();
    filterOptions?.filter = FlightFilter(
        cabinClassOptions: filterOptions.filter?.cabinClassOptions,
        ticketPolicyOptions: filterOptions.filter?.ticketPolicyOptions,
        airlineOptions: filterOptions.filter?.airlineOptions,
        stopOptions: filterOptions.filter?.stopOptions,
        step: filterOptions.filter?.step ?? '1',
        departureDateTimeOptions: filterOptions.filter?.departureDateTimeOptions,
        arrivalDateTimeReturnOptions: filterOptions.filter?.arrivalDateTimeReturnOptions,
        arrivalDateTimeOptions: filterOptions.filter?.arrivalDateTimeOptions,
        priceItineraryId: filterOptions.filter?.priceItineraryId,
        loadMore: filterOptions.filter?.loadMore ?? true,
        departureDateTimeReturnOptions: filterOptions.filter?.departureDateTimeReturnOptions,
        filterFromPrice: filterOptions.filter?.filterFromPrice,
        filterToPrice: filterOptions.filter?.filterToPrice,
        groupId: result.groupId,
        flightType: result.flightType);

    GtdFlightItinerary flightItinerary = GtdFlightItinerary(
        page: Page(nextPageNumber: -1, totalPage: 1, pageNumber: 0),
        flightDirection: flightDirection,
        flightItems: items,
        filterOptions: filterOptions);
    return flightItinerary;
  }

  String get deapartureDate {
    DateTime? dateTime = flightItems?.firstOrNull?.flightItemInfo?.originDateTime;
    return dateTime?.utcDate("EEEE, dd/MM/yyyy") ?? "__/__/__";
  }

  String get returnDate {
    DateTime? dateTime = flightItems?.firstOrNull?.flightItemInfo?.destinationDateTime;
    return dateTime?.utcDate("EEEE, dd/MM/yyyy") ?? "__/__/__";
  }

  GtdFlightItem? get selectedFlightItem {
    GtdFlightItem? flightItem =
        flightItems?.map((e) => e).where((element) => element.selectedCabinOption != null).firstOrNull;
    return flightItem;
  }
}

extension GtdFlightItineraryMapper on GtdFlightItinerary {
  void updateFlightItinerary(GtdFlightItinerary flightItinerary) {
    filterOptions = flightItinerary.filterOptions;
    List<GtdFlightItem> flightItemsResult = [...?flightItems, ...?flightItinerary.flightItems];
    flightItems = flightItemsResult;
    page = flightItinerary.page;
  }
}
