import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_combo_repository/gtd_combo_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/gtd_hotel_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

part 'add_booking_traveler_state.dart';

class AddBookingTravelerCubit extends Cubit<AddBookingTravelerState> {
  AddBookingTravelerCubit() : super(AddBookingTravelerInitial());

  Future<Result<AddBookingTravellerRs, GtdApiError>> addBookingTraveller(
      AddBookingTravellerRq addBookingTravellerRq, String supplierType) async {
    if (supplierType == "AIR") {
      var result = await GtdFlightRepository.shared.addBookingTraveller(addBookingTravellerRq).then((value) async {
        var mappingResult = value.when<Result<AddBookingTravellerRs, GtdApiError>>((success) {
          /// Handle OTP here
          return Success(success);
        }, (error) {
          return Error(error);
        });

        //Handle mappingResult for show popup OTP
        return mappingResult;
      });
      return result;
    }
    if (supplierType == "HOTEL") {
      var result = await GtdHotelRepository.shared.addBookingTraveller(addBookingTravellerRq).then((value) async {
        var mappingResult = value.when<Result<AddBookingTravellerRs, GtdApiError>>((success) {
          /// Handle OTP here
          return Success(success);
        }, (error) {
          return Error(error);
        });

        //Handle mappingResult for show popup OTP
        return mappingResult;
      });
      return result;
    }
    if (supplierType == "COMBO") {
      var result = await GtdComboRepository.shared.addBookingTraveller(addBookingTravellerRq).then((value) async {
        var mappingResult = value.when<Result<AddBookingTravellerRs, GtdApiError>>((success) {
          /// Handle OTP here
          return Success(success);
        }, (error) {
          return Error(error);
        });

        //Handle mappingResult for show popup OTP
        return mappingResult;
      });
      return result;
    }
    return Error(GtdApiError(message: "Không có booking supplier"));
  }
}
