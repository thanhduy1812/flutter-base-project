part of 'hotel_search_detail_cubit.dart';

sealed class HotelSearchDetailState extends Equatable {
  const HotelSearchDetailState();

  @override
  List<Object> get props => [];
}

final class HotelSearchDetailInitial extends HotelSearchDetailState {}

final class HotelSearchDetailLoading extends HotelSearchDetailState {}

final class HotelSearchDetailLoaded extends HotelSearchDetailState {
  final GtdHotelSearchDetailDTO searchDetailDTO;

  const HotelSearchDetailLoaded(this.searchDetailDTO);
}

final class HotelSearchDetailError extends HotelSearchDetailState {
  final GtdApiError apiError;

  const HotelSearchDetailError(this.apiError);

  @override
  List<Object> get props => [apiError];
}
