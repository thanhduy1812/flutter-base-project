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
  const SelectDestinationLocation({super.destination});
}

class SelectDateForm extends FormSearchEvent {
  const SelectDateForm({super.searchDate});
}

class SetIsRoundTrip extends FormSearchEvent {
  const SetIsRoundTrip({super.isRoundTrip});
}

class SetPassenger extends FormSearchEvent {
  const SetPassenger({super.passengers});
}
