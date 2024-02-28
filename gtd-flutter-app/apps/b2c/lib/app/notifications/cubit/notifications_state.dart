part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  final GtdNotifySenderMethod senderMethod;
  const NotificationsState(this.senderMethod);

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  final GtdNotificationsRs? notificationsRs;

  const NotificationsInitial(super.senderMethod, {this.notificationsRs});

  @override
  List<Object> get props => [notificationsRs?.content ?? []];
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading(super.senderMethod);

  @override
  List<Object> get props => [UniqueKey()];
}

final class NotificationsLoadingMore extends NotificationsState {
  const NotificationsLoadingMore(super.senderMethod);

  @override
  List<Object> get props => [UniqueKey()];
}

final class NotificationsLoadedMore extends NotificationsState {
  final GtdNotificationsRs? notificationsRs;

  const NotificationsLoadedMore(super.senderMethod, {this.notificationsRs});

  @override
  List<Object> get props => [notificationsRs ?? UniqueKey()];
}
