part of 'flight_filter_options_cubit.dart';

abstract class FlightFilterOptionsState extends Equatable {
  @override
  List<Object> get props => [];

  FlightFilterOptionsState copyWith(
      {required List<AllFilterOptionsDTO> allFilterOptionsDTO,
      GtdApiError? apiError}) {
    return FlightFilterOptionsInitial(allFilterOptionsDTO: allFilterOptionsDTO);
  }
}

class FlightFilterOptionsInitial extends FlightFilterOptionsState {
    late final List<AllFilterOptionsDTO> allFilterOptionsDTO;
  FlightFilterOptionsInitial(
      {required List<AllFilterOptionsDTO>? allFilterOptionsDTO}) {
    this.allFilterOptionsDTO = allFilterOptionsDTO!;
  }
  FlightFilterOptionsInitial.defaultState() {
    allFilterOptionsDTO = [];
  }
    @override
  List<Object> get props => [allFilterOptionsDTO];
}

class FlightFilterLoadingState extends FlightFilterOptionsState {
  FlightFilterLoadingState();
}

class FlightFilterErrorState extends FlightFilterOptionsState {
  late final GtdApiError? apiError;
  FlightFilterErrorState(this.apiError);
}

class FlightFilterAppliedState extends FlightFilterOptionsState {
  final bool isApplyFilter;
  FlightFilterAppliedState(this.isApplyFilter);
}
