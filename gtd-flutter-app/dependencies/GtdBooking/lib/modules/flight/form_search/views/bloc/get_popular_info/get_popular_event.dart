part of 'get_popular_bloc.dart';

abstract class GetPopularEvent extends Equatable {
  const GetPopularEvent();
  @override
  List<Object> get props => [];
}

class GetAllPopularFetched extends GetPopularEvent {
  const GetAllPopularFetched() : super();
}