import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_search_state.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/network/gtd_app_logger.dart';
import 'package:gtd_utils/data/network/models/wrapped_result/result.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/gtd_booking_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/form_search_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_itinerary.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/sort_value.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:rxdart/rxdart.dart';

class FlightSearchCubit extends Cubit<FlightSearchState> {
  FlightSearchCubit() : super(FlightSearchLoadStatusState(status: FlightSearchStatus.isLoading));
  //Subject for keep main stream
  BehaviorSubject<SearchFlightFormModel> formSearchInfoSubject = BehaviorSubject<SearchFlightFormModel>();
  BehaviorSubject<GtdFlightSearchResultDTO> flightSearchSubject = BehaviorSubject<GtdFlightSearchResultDTO>();
  BehaviorSubject<GtdFlightItinerary> flightItinerarySubject = BehaviorSubject<GtdFlightItinerary>();

  StreamSubscription<dynamic>? _cancelableSub;
  
  void initFlightFormSearch(SearchFlightFormModel searchFlightFormModel) {
    formSearchInfoSubject.sink.add(searchFlightFormModel);
  }

  void initFlightSearchResultDTO(GtdFlightSearchResultDTO flightSearchResultDTO) {
    flightSearchSubject.sink.add(flightSearchResultDTO);
  }

  void loadLowSearch(SearchFlightFormModel? formSearchModel) {
    if (formSearchModel != null) {
      formSearchInfoSubject = BehaviorSubject.seeded(formSearchModel);
      //Cached SearchInfo
      CacheHelper.shared.saveSharedObject(formSearchModel.toCachedObject(), key: CacheStorageType.flightBox.name);
      _cancelableSub = lowFareSearch(formSearchModel).asStream().listen((resultSearch) {
        resultSearch.when((success) {
          success.isRoundTrip = formSearchModel.isRoundTrip;
          flightSearchSubject.add(success);
          emit(FlightSearchLoadStatusState(status: FlightSearchStatus.success));
          Logger.i(success.toString());
        }, (error) {
          emit(FlightSearchErrorState(apiError: error));
          Logger.e(error.message);
        });
      });
    }
  }

  void loadComboFlightSearch(
      {required SearchFlightFormModel formSearchModel,
      required Sink<({bool isLoaded, GtdFlightSearchResultDTO? data})> flightSearchSink}) {
    CacheHelper.shared.saveSharedObject(formSearchModel.toCachedObject(), key: CacheStorageType.comboFlightBox.name);
    _cancelableSub = searchFlightCombo(formSearchModel).asStream().listen((resultSearch) {
      resultSearch.when((success) {
        success.isRoundTrip = formSearchModel.isRoundTrip;
        flightSearchSink.add((isLoaded: true, data: success));
        Logger.i(success.toString());
      }, (error) {
        Logger.e(error.message);
      });
    });
  }

  Future<Result<GtdFlightSearchResultDTO, GtdApiError>> searchFlightCombo(SearchFlightFormModel formSearchModel) async {
    FormSearchPayloadModel info = FormSearchPayloadModel(
        gtdLocationInfo: GtdLocationInfo(
          destinationCode: formSearchModel.toLocation.code,
          originCode: formSearchModel.fromLocation.code,
        ),
        dateItinerary: DateItinerary(
            departureDate: formSearchModel.departDate,
            returnDate: formSearchModel.returnDate,
            routeType: (formSearchModel.isRoundTrip) ? 'ROUNDTRIP' : 'ONEWAY'),
        passengersItinerary: PassengersItinerary(
          adult: formSearchModel.adult,
          child: formSearchModel.child,
          inf: formSearchModel.infant,
        ));
    final resultSearch = await GtdFlightRepository.shared.searchFlightCombo(info);
    return resultSearch;
  }

  Future<Result<GtdFlightSearchResultDTO, GtdApiError>> lowFareSearch(SearchFlightFormModel? formSearchModel) async {
    emit(FlightSearchLoadStatusState(status: FlightSearchStatus.isLoading));
    FormSearchPayloadModel info = FormSearchPayloadModel(
        gtdLocationInfo: GtdLocationInfo(
          destinationCode: formSearchModel?.toLocation.code,
          originCode: formSearchModel?.fromLocation.code,
        ),
        dateItinerary: DateItinerary(
            departureDate: formSearchModel?.departDate,
            returnDate: formSearchModel?.returnDate,
            routeType: (formSearchModel?.isRoundTrip ?? false) ? 'ROUNDTRIP' : 'ONEWAY'),
        passengersItinerary: PassengersItinerary(
          adult: formSearchModel?.adult,
          child: formSearchModel?.child,
          inf: formSearchModel?.infant,
        ));
    final resultSearch = await GtdFlightRepository.shared.searchFlightCombine(info);
    return resultSearch;
  }

  Future<void> cancelSearch() async {
    _cancelableSub?.cancel();
    emit(FlightSearchLoadStatusState(status: FlightSearchStatus.cancel));
  }

  Future<Result<GtdFlightSearchResultDTO, GtdApiError>> filterAvailableFlight(
      {required FilterAvailabilityRq filterRq, required FlightDirection flightDirection}) async {
    Result<GtdFlightSearchResultDTO, GtdApiError> result =
        await GtdFlightRepository.shared.flightFilterAvailabilityPaging(filterRq, flightDirection);
    return result;
  }

  Future<void> filterAvailabilityWithPaging(
      FilterAvailabilityRq filterAvailabilityRq, FlightDirection flightDirection) async {
    emit(FlightSearchLoadingState());
    var result = await filterAvailableFlight(filterRq: filterAvailabilityRq, flightDirection: flightDirection);
    result.when((success) => emit(FlightSearchLoadedState(flightSearchResultDTO: success)),
        (error) => emit(FlightSearchErrorState(apiError: error)));
  }

  Future<void> loadMoreFlights(FilterAvailabilityRq filterAvailabilityRq, FlightDirection flightDirection) async {
    var result = await filterAvailableFlight(filterRq: filterAvailabilityRq, flightDirection: flightDirection);
    result.when((success) => emit(FlightSearchLoadedState(flightSearchResultDTO: success)),
        (error) => emit(FlightSearchErrorState(apiError: error)));
  }

  Future<void> refreshPage(FilterAvailabilityRq filterAvailabilityRq, FlightDirection flightDirection) async {
    emit(FlightSearchLoadingState());
    var result = await filterAvailableFlight(filterRq: filterAvailabilityRq, flightDirection: flightDirection);
    result.when((success) => emit(FlightSearchLoadedState(flightSearchResultDTO: success)),
        (error) => FlightSearchErrorState(apiError: error));
  }

  Future<void> sortFLights(
      {required FilterAvailabilityRq filterAvailabilityRq,
      required FlightDirection flightDirection,
      required GtdFlightSearchResultDTO flightSearchResultDTO}) async {
    emit(FlightSearchLoadingState());
    var result = await filterAvailableFlight(filterRq: filterAvailabilityRq, flightDirection: flightDirection);
    result.when((success) => emit(FlightSearchLoadedState(flightSearchResultDTO: success)),
        (error) => FlightSearchErrorState(apiError: error));
  }

  Future<Result<BookingDetailDTO, GtdApiError>> draftBooking(GtdFlightDraftBookingRq draftBookingRq) async {

    return GtdFlightRepository.shared.draftBooking(draftBookingRq).then((value) async {
      var result = await value.when((success) async {
        return success.bookingNumber;
      }, (error) {
        //Emit show popup error
        emit(FlightSearchErrorState(apiError: error));
      });
      return result;
    }).then((value) {
      if ((value ?? "").isNotEmpty) {
        return GtdBookingRepository.shared.getBookingDetailByBookingNumber(value!);
      } else {
        return Error(GtdApiError(message: "Booking not found"));
      }
    });
  }

  @override
  Future<void> close() {
    flightSearchSubject.close();
    flightItinerarySubject.close();
    formSearchInfoSubject.close();
    return super.close();
  }
}

class FlightSearchDomCubit extends FlightSearchCubit {}

class FlightSearchInteCubit extends FlightSearchCubit {
  @override
  Future<Result<GtdFlightSearchResultDTO, GtdApiError>> filterAvailableFlight(
      {required FilterAvailabilityRq filterRq, required FlightDirection flightDirection}) async {
    if (flightDirection == FlightDirection.d) {
      return super.filterAvailableFlight(filterRq: filterRq, flightDirection: flightDirection);
    } else {
      FilterAvailabilityRq filterInte = filterRq.createFilterGroupItenaryRq();
      String? groupId = filterRq.departureItinerary?.groupId;
      if ((groupId ?? "").isNotEmpty) {
        var result = await GtdFlightRepository.shared.groupItinerary(filterInte, groupId!);
        Result<GtdFlightSearchResultDTO, GtdApiError> finalResult = result.when((success) {
          GtdFlightItinerary? flightItineraryRs =
              GtdFlightItinerary.fromGroupPricedItinerary(success, filterRq, flightDirection);
          //Extract flighItems from cabin class
          var flighItems = (flightItineraryRs.flightItems ?? [])
              .map((item) {
                var items = (item.cabinOptions ?? []).map((e) {
                  GtdFlightItem flightItem = item.copyWith(cabinOptions: [e]);
                  return flightItem;
                }).toList();
                return items;
              })
              .flattened
              .toList();
          flightItineraryRs.flightItems = flighItems;
          GtdFlightSearchResultDTO flightSearchResultDTO = flightSearchSubject.value;
          flightSearchResultDTO.returnItinerary = flightItineraryRs;
          return Success(flightSearchResultDTO);
        }, (error) {
          return Error(error);
        });
        return finalResult;
      } else {
        return Error(GtdApiError(message: "Group id is null"));
      }
    }
  }

  @override
  Future<void> sortFLights(
      {required FilterAvailabilityRq filterAvailabilityRq,
      required FlightDirection flightDirection,
      required GtdFlightSearchResultDTO flightSearchResultDTO}) async {
    if (flightDirection == FlightDirection.d) {
      super.sortFLights(
          filterAvailabilityRq: filterAvailabilityRq,
          flightDirection: flightDirection,
          flightSearchResultDTO: flightSearchResultDTO);
    } else {
      emit(FlightSearchLoadingState());
      flightSearchResultDTO.returnItinerary?.flightItems?.sort(
        (a, b) {
          switch (filterAvailabilityRq.sort) {
            case FlightSortValue.departureDateAsc:
              return a.compareDepartureDate(b);
            case FlightSortValue.departureDateDesc:
              return b.compareDepartureDate(a);
            case FlightSortValue.priceAsc:
              return a.comparePrice(b);
            case FlightSortValue.priceDesc:
              return b.comparePrice(a);
            case FlightSortValue.durationAsc:
              return a.compareDuration(b);
            case FlightSortValue.durationDesc:
              return b.compareDuration(a);
            default:
              return a.compareDuration(b);
          }
        },
      );
      emit(FlightSearchLoadedState(flightSearchResultDTO: flightSearchResultDTO));
    }
  }
}
