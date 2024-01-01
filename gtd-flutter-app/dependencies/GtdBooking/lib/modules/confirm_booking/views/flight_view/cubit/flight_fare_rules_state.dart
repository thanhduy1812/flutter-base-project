part of 'flight_fare_rules_cubit.dart';

sealed class FlightFareRulesState extends Equatable {
  const FlightFareRulesState();

  @override
  List<Object> get props => [];
}

final class FlightFareRulesInitial extends FlightFareRulesState {
  final List<BookedFareRule> bookedFareRules;

  const FlightFareRulesInitial(this.bookedFareRules);
  @override
  List<Object> get props => [bookedFareRules];
}
