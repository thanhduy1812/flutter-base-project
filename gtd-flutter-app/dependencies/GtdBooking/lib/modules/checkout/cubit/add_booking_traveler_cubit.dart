import 'package:dvt_helper/dvt_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_repository/gtd_repository.dart';


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
