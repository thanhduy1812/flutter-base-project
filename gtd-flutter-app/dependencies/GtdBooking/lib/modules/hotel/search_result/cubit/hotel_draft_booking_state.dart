part of 'hotel_draft_booking_cubit.dart';

sealed class HotelDraftBookingState extends Equatable {
  const HotelDraftBookingState();

  @override
  List<Object> get props => [];
}

final class HotelDraftBookingInitial extends HotelDraftBookingState {}

final class HotelDraftBookingLoading extends HotelDraftBookingState {}

final class HotelDraftBookingError extends HotelDraftBookingState {
  final GtdApiError apiError;

  const HotelDraftBookingError(this.apiError);
  @override
  List<Object> get props => [apiError];
}

final class HotelDraftBookingLoaded extends HotelDraftBookingState {
  final BookingDetailDTO bookingDetailDTO;

  const HotelDraftBookingLoaded(this.bookingDetailDTO);
  @override
  List<Object> get props => [bookingDetailDTO];
}
