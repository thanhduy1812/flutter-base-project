

import 'location.dart';
import 'passengers.dart';

class SearchFlightInfo {
  SearchFlightInfo({
    this.location,
    this.searchDate,
    this.isRoundTrip = true,
    this.passengers,
  });

  Location? location;
  SearchDate? searchDate;
  bool? isRoundTrip;
  Passengers? passengers;
}

class SearchDate {
  SearchDate({
    this.departureDate,
    this.returnTureDate,
  });

  DateTime? departureDate;
  DateTime? returnTureDate;
}

