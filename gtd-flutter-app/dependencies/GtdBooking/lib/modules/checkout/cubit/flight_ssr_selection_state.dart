part of 'flight_ssr_selection_cubit.dart';

abstract class FlightSsrSelectionState extends Equatable {
  const FlightSsrSelectionState();

  @override
  List<Object> get props => [UniqueKey()];
}

class FlightSsrSelectionInitial extends FlightSsrSelectionState {}
