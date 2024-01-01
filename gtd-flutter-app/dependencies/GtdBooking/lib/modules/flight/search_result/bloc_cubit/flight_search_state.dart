import 'package:equatable/equatable.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

enum FlightSearchStatus { isLoading, isLoadMore, success, cancel }

sealed class FlightSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class FlightSearchInitState extends FlightSearchState {
  late final GtdFlightSearchResultDTO flightLowSearchRs;
  late final FlightDirection flightDirection;
  // late bool isRoundTrip = false;

  // GtdApiError? apiError;
  FlightSearchInitState({required this.flightLowSearchRs, required this.flightDirection});

  FlightSearchInitState.defaultState() {
    flightLowSearchRs = GtdFlightSearchResultDTO();
  }

  FlightSearchInitState.initState(GtdFlightSearchResultDTO dto) {
    flightLowSearchRs = dto;
  }

  @override
  List<Object> get props => [flightLowSearchRs];

  FlightSearchInitState copyWith({
    GtdFlightSearchResultDTO? flightLowSearchRs,
    FlightDirection? flightDirection,
    GtdApiError? apiError,
  }) {
    return FlightSearchInitState(
      flightLowSearchRs: flightLowSearchRs ?? this.flightLowSearchRs,
      flightDirection: flightDirection ?? this.flightDirection,
    );
  }
}

class FlightSearchLoadStatusState extends FlightSearchState {
  late final FlightSearchStatus status;
  FlightSearchLoadStatusState({required this.status});

  @override
  List<Object> get props => [status];
}

class FlightSearchLoadingState extends FlightSearchState {
  FlightSearchLoadingState();
}

class FlightSearchLoadedState extends FlightSearchState {
  final GtdFlightSearchResultDTO flightSearchResultDTO;
  FlightSearchLoadedState({required this.flightSearchResultDTO});
  @override
  List<Object> get props => [flightSearchResultDTO];
}

class FlightSearchRefeshState extends FlightSearchState {
  final GtdFlightSearchResultDTO flightSearchResultDTO;
  FlightSearchRefeshState({required this.flightSearchResultDTO});
  @override
  List<Object> get props => [flightSearchResultDTO];
}

class FlightSearchLoadingMoreState extends FlightSearchState {
  FlightSearchLoadingMoreState();
}

class FlightSearchErrorState extends FlightSearchState {
  late final GtdApiError apiError;
  FlightSearchErrorState({required this.apiError});

  @override
  List<Object> get props => [apiError];
}
