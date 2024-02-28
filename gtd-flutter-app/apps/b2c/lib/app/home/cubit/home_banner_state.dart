part of 'home_banner_cubit.dart';

sealed class HomeBannerState extends Equatable {
  const HomeBannerState();

  @override
  List<Object> get props => [];
}

final class HomeBannerInitial extends HomeBannerState {}
final class HomeBannerLoading extends HomeBannerState {}
