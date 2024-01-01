// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'flight_service_request_cubit.dart';

abstract class FlightServiceRequestState extends Equatable {
  const FlightServiceRequestState();

  @override
  List<Object> get props => [];
}

class FlightServiceRequestInitial extends FlightServiceRequestState {}

class FlightServiceRequestLoaded extends FlightServiceRequestState {
  final List<SsrOfferDTO> ssrOfferDTOs;
  const FlightServiceRequestLoaded({
    required this.ssrOfferDTOs,
  });

  @override
  List<Object> get props => [ssrOfferDTOs];
}

class FlightServiceRequestLoading extends FlightServiceRequestState {}
