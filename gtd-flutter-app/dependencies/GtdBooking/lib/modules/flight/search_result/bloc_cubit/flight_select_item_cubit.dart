import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_select_item_state.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/models/request/filter_availability_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';

class FlightSelectItemCubit extends Cubit<FlightSelectItemState> {
  FlightSelectItemCubit(this.flightType) : super(FlightSelectInitItemState.defaultState());

  /// Stream that will be cleaned on close
  StreamSubscription? _stream;
  FlightType flightType;
  void initFlightSelectItemState(GtdFlightItem? flightItem) {
    emit(FlightSelectInitItemState.defaultState());
  }

  void setSelectedFlightItem(GtdFlightItem? flightItem) {
    if (flightItem != null) {
      emit(state.copyWith(flightItem: flightItem));
    }
  }

  void toggleLoading(bool isLoading, GtdFlightItem flightItem) {
    emit(FlightSelectItemLoadingState(
        flightItem: flightItem,
        loadingStatus:
            isLoading ? FlightSelectItemStatus.loading : FlightSelectItemStatus.success));
  }

  Future<void> fetchCabinClass(FilterAvailabilityRq? filterAvailabilityRq, GtdFlightItem flightItem,
      FlightDirection flightDirection) async {
    //TODO: Handle Future API fetch and update cabin class into FlightItem here
    toggleLoading(true, flightItem);
    FilterAvailabilityRq cabinOptionFilter = FilterAvailabilityRq.createFilterRq(
        flightDirection: flightDirection,
        searchId: filterAvailabilityRq!.searchId,
        flightType: flightType);
    cabinOptionFilter.filter?.groupId = flightItem.groupId;
    cabinOptionFilter.filter?.loadMore = true;
    cabinOptionFilter.filter?.step = "1";
    cabinOptionFilter.searchId = filterAvailabilityRq.searchId;
    if (flightType == FlightType.inte && flightDirection == FlightDirection.r) {
      toggleLoading(false, flightItem);
    } else {
      await GtdFlightRepository.shared
          .groupItinerary(cabinOptionFilter, flightItem.groupId!)
          .then((value) {
        value.whenSuccess((success) async {
          flightItem.updateCabinOptions(success, flightDirection);
          toggleLoading(false, flightItem);
        });
      });
    }
  }

  void getCurrentState() {
    emit(state);
  }

  @override
  Future<void> close() {
    _stream?.cancel();
    return super.close();
  }
}
