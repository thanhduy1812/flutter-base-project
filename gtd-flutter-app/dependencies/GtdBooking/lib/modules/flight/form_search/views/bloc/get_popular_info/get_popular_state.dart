part of 'get_popular_bloc.dart';

enum GetPopularStatus { initial, loading, success, failure }

class GetPopularState extends Equatable {
  const GetPopularState({
    this.status = GetPopularStatus.initial,
    this.popularAirportRS,
  });

  final GetPopularStatus status;
  final GtdPopularAirportRS? popularAirportRS;

  GetPopularState copyWith({
    GetPopularStatus? status,
    GtdPopularAirportRS? popularAirportRS
  }) {
    return GetPopularState(
      status: status ?? this.status,
      popularAirportRS: popularAirportRS ?? this.popularAirportRS,
    );
  }

  @override
  String toString() {
    return '''GetPopularState { status: $status, popularAirportRS: $popularAirportRS }''';
  }

  @override
  List<Object> get props => [status];
}