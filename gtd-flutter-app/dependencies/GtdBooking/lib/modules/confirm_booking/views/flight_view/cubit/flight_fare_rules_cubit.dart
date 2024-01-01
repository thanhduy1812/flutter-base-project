import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';

part 'flight_fare_rules_state.dart';

class FlightFareRulesCubit extends Cubit<FlightFareRulesState> {
  FlightFareRulesCubit() : super(const FlightFareRulesInitial([]));

  Future<void> flightFareRules(String bookingNumber) async {
    final bookedFareRules = await GtdFlightRepository.shared.flightFareRuleByBooking(bookingNumber);
    bookedFareRules.when((success) {
      emit(FlightFareRulesInitial(success));
    }, (error) {
      emit(const FlightFareRulesInitial([]));
    });
  }
}
