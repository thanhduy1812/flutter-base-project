part of 'form_search_bloc.dart';

abstract class FormSearchEvent extends Equatable {
  final Destination? destination;
  final SearchDate? searchDate;
  final bool? isRoundTrip;
  final SearchFlightInfo? formSearchModel;
  final Passengers? passengers;

  const FormSearchEvent({
    this.destination,
    this.formSearchModel,
    this.searchDate,
    this.isRoundTrip,
    this.passengers,
  });
  @override
  List<Object?> get props => [destination, searchDate];
}

class SelectDestinationLocation extends FormSearchEvent {
  @override
  final Destination? destination;
  const SelectDestinationLocation({this.destination}) : super(destination: destination);
}

class SelectDateForm extends FormSearchEvent {
  @override
  final SearchDate? searchDate;
  const SelectDateForm({this.searchDate}) : super(searchDate: searchDate);
}

class SetIsRoundTrip extends FormSearchEvent {
  @override
  final bool? isRoundTrip;
  const SetIsRoundTrip({this.isRoundTrip}) : super(isRoundTrip: isRoundTrip);
}

class SetPassenger extends FormSearchEvent {
  @override
  final Passengers? passengers;
  const SetPassenger({this.passengers}) : super(passengers: passengers);
}
