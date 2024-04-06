part of 'get_location_bloc.dart';

abstract class GetLocationEvent extends Equatable {
  final String keyword;
  const GetLocationEvent({required this.keyword});
  @override
  List<Object> get props => [keyword];
}

class GetLocationFetched extends GetLocationEvent {
  const GetLocationFetched({super.keyword = ''});
}
