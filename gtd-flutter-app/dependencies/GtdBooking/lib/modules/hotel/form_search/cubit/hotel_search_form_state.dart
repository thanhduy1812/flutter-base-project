part of 'hotel_search_form_cubit.dart';

sealed class HotelSearchFormState extends Equatable {
  const HotelSearchFormState();

  @override
  List<Object> get props => [];
}

final class HotelSearchFormInitial extends HotelSearchFormState {}

final class HotelSearchFormInitViewModel extends HotelSearchFormState {
  final SearchHotelPageViewModel viewModel;

  const HotelSearchFormInitViewModel(this.viewModel);
}
