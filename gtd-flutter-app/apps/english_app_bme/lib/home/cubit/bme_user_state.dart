part of 'bme_user_cubit.dart';

@immutable
sealed class BmeUserState {}

final class BmeUserInitial extends BmeUserState {
  final List<BmeUser> bmeUsers;

  BmeUserInitial({required this.bmeUsers});
}

final class BmeUserLoading extends BmeUserState {}

final class BmeUserError extends BmeUserState {}
