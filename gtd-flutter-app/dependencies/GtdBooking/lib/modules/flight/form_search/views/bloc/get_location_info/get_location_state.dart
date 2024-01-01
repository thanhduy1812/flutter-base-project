part of 'get_location_bloc.dart';

enum GetLocationStatus { initial, loading, success, failure }

class GetLocationState extends Equatable {
  const GetLocationState({
    this.status = GetLocationStatus.initial,
    this.hasReachedMax = false,
    this.keyword = '',
    this.cities = const <SearchAirport>[],
  });

  final GetLocationStatus status;
  final bool hasReachedMax;
  final String keyword;
  final List<SearchAirport> cities;

  GetLocationState copyWith({
    GetLocationStatus? status,
    bool? hasReachedMax,
    String? keyword,
    List<SearchAirport>? cities
  }) {
    return GetLocationState(
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      cities: cities ?? this.cities,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, keyword: $keyword, cities: $cities }''';
  }

  @override
  List<Object> get props => [status, hasReachedMax, keyword, cities];
}

