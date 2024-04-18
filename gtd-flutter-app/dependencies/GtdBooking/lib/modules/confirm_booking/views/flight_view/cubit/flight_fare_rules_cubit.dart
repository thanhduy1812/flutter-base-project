import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_repository/gtd_repository.dart';

part 'flight_fare_rules_state.dart';

class FlightFareRulesCubit extends Cubit<FlightFareRulesState> {
  FlightFareRulesCubit() : super(const FlightFareRulesInitial([]));

  Future<void> flightFareRules(String bookingNumber) async {
    if (bookingNumber.isEmpty) {
      (const FlightFareRulesInitial([]));
      return;
    }
    final bookedFareRules = await GtdFlightRepository.shared.flightFareRuleByBooking(bookingNumber);
    bookedFareRules.when((success) {
      emit(FlightFareRulesInitial(success));
    }, (error) {
      emit(const FlightFareRulesInitial([]));
    });
  }
}
