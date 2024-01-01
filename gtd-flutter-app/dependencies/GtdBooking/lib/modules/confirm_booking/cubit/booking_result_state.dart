part of 'booking_result_cubit.dart';

enum BookingDetailStatus { isLoading, success, cancel }

abstract class BookingResultState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookingResultInitial extends BookingResultState {}

class BookingDetailLoadingState extends BookingResultState {
  late final BookingDetailStatus status;
  BookingDetailLoadingState({required this.status});

  @override
  List<Object> get props => [status];
}

class BookingDetailErrorState extends BookingResultState {
  late final GtdApiError apiError;
  BookingDetailErrorState({required this.apiError});

  @override
  List<Object> get props => [apiError];
}