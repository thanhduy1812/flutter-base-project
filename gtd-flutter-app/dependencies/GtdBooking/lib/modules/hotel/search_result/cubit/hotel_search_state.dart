part of 'hotel_search_cubit.dart';

sealed class HotelSearchState extends Equatable {
  const HotelSearchState();

  @override
  List<Object> get props => [];
}

final class HotelSearchInitial extends HotelSearchState {}

final class HotelSearchError extends HotelSearchState {
  final GtdApiError apiError;

  const HotelSearchError({required this.apiError});
}

final class HotelSearchLoading extends HotelSearchState {}

final class HotelSearchLoaded extends HotelSearchState {
  final GtdHotelSearchResultDTO hotelSearchResultDTO;

  const HotelSearchLoaded(this.hotelSearchResultDTO);
  @override
  List<Object> get props => [hotelSearchResultDTO];
}

final class HotelSortLoaded extends HotelSearchState {
  final GtdHotelSearchResultDTO hotelSearchResultDTO;

  const HotelSortLoaded(this.hotelSearchResultDTO);
  @override
  List<Object> get props => [hotelSearchResultDTO];
}

final class HotelSearchLoadmoreLoaded extends HotelSearchState {
  final GtdHotelSearchResultDTO hotelSearchResultDTO;

  const HotelSearchLoadmoreLoaded(this.hotelSearchResultDTO);
  @override
  List<Object> get props => [hotelSearchResultDTO];
}
