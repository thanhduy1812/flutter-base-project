part of 'my_booking_cubit.dart';

enum MyBookingStatus { isLoading, isLoadMore, success, cancel }

abstract class MyBookingState extends Equatable {
  @override
  List<Object> get props => [];

  MyBookingState copyWith({required SearchBookingRs searchBookingRs, GtdApiError? apiError}) {
    return MyBookingInitState(searchBookingRs: searchBookingRs);
  }
}

class MyBookingInitState extends MyBookingState {
  late final SearchBookingRs searchBookingRs;

  MyBookingInitState({required this.searchBookingRs});

  @override
  List<Object> get props => [searchBookingRs];

  @override
  MyBookingInitState copyWith({
    SearchBookingRs? searchBookingRs,
    GtdApiError? apiError,
  }) {
    return MyBookingInitState(
      searchBookingRs: searchBookingRs ?? this.searchBookingRs,
    );
  }
}

class MyBookingLoadingState extends MyBookingState {
  late final MyBookingStatus status;
  MyBookingLoadingState({required this.status});

  @override
  List<Object> get props => [status, UniqueKey()];
}

class MyBookingErrorState extends MyBookingState {
  final GtdApiError apiError;
  MyBookingErrorState({required this.apiError});
}

class MyBookingInitial extends MyBookingState {}
