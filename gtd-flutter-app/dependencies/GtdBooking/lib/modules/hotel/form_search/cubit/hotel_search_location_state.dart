part of 'hotel_search_location_cubit.dart';

sealed class HotelSearchLocationState extends Equatable {
  const HotelSearchLocationState();

  @override
  List<Object> get props => [];
}

final class HotelSearchLocationInitial extends HotelSearchLocationState {}

final class HotelSearchLocationLoading extends HotelSearchLocationState {
  @override
  List<Object> get props => [UniqueKey()];
}

final class HotelSearchLocationError extends HotelSearchLocationState {
  final GtdApiError apiError;
  const HotelSearchLocationError(this.apiError);
  @override
  List<Object> get props => [apiError];
}

final class HotelPopularLocationLoaded extends HotelSearchLocationState {
  final List<GtdHotelLocationDTO> hotelLocations;
  const HotelPopularLocationLoaded(this.hotelLocations);
  @override
  List<Object> get props => [hotelLocations];
}

final class HotelSearchLocationLoaded extends HotelSearchLocationState {
  final List<GtdHotelLocationDTO> hotelLocations;
  const HotelSearchLocationLoaded(this.hotelLocations);
  @override
  List<Object> get props => [hotelLocations];
}