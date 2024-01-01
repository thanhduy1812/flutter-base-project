part of 'saved_traveller_cubit.dart';

abstract class SavedTravellerState extends Equatable {
  // const SavedTravellerState({this.travellers = const []});

  // @override
  // List<Object> get props => [travellers];
}

class SavedTravellerStateLoading extends SavedTravellerState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class SavedTravellerInitial extends SavedTravellerState {
  final List<GtdSavedTravellerRs> travellers;
  SavedTravellerInitial({this.travellers = const []});

  @override
  List<Object?> get props => [travellers];
}

