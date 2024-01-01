import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

part 'flight_service_request_state.dart';

class FlightServiceRequestCubit extends Cubit<FlightServiceRequestState> {
  BookingDetailDTO bookingDetailDTO;
  FlightServiceRequestCubit({required this.bookingDetailDTO}) : super(FlightServiceRequestInitial());

  void initWithServiceRequest(List<SsrOfferDTO> ssrOfferDTOs) {
    emit(FlightServiceRequestLoaded(ssrOfferDTOs: ssrOfferDTOs));
  }

  Future<Result<List<SsrOfferDTO>, GtdApiError>> getServiceRequests() async {
    String bookingNumber = bookingDetailDTO.bookingNumber!;
    List<SsrOfferDTO> ssrOfferDTOs;
    emit(FlightServiceRequestLoading());
    try {
      return await GtdFlightRepository.shared.getServiceRequests(bookingNumber).then((value) {
        return value.when((success) {
          ssrOfferDTOs = success.map(
            (ssrDTO) {
              var fareSourceCode = bookingDetailDTO.flightDetailItems
                  ?.firstWhere((e) => e.flightDirection == ssrDTO.bookingDirection)
                  .flightItem
                  .cabinOptions
                  ?.first
                  .fareSourceCode;
              ssrDTO.fareCode = fareSourceCode ?? "";
              return ssrDTO;
            },
          ).toList();
          emit(FlightServiceRequestLoaded(ssrOfferDTOs: ssrOfferDTOs));
          return Success(ssrOfferDTOs);
          // }, (error) => Error(error));
        }, (error) {
          emit(const FlightServiceRequestLoaded(ssrOfferDTOs: []));
          return const Success([]);
        });
      });
    } on GtdApiError catch (e) {
      Logger.e(e.message);
      emit(const FlightServiceRequestLoaded(ssrOfferDTOs: []));
      return const Success([]);
    } catch (e) {
      Logger.e(e.toString());
      emit(const FlightServiceRequestLoaded(ssrOfferDTOs: []));
      return const Success([]);
      // return Error(GtdApiError(message: "Error addbooking traveller"));
    }
  }
}
