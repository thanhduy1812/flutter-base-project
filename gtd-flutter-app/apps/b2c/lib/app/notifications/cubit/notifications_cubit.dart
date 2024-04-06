import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/utility_resource/utility_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_utility_repository/gtd_utility_repository.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  String userRefCode = "";
  NotificationsCubit() : super(const NotificationsInitial(GtdNotifySenderMethod.private));

  void loadAccountInfo() async {
    emit(const NotificationsLoading(GtdNotifySenderMethod.private));
    await GtdAuthenticationRepository.shared.getAccountInfo().then((value) {
      value.when((success) {
        userRefCode = success.userRefCode ?? "";
        loadNotifications(GtdNotifySenderMethod.private);
      }, (error) {
        loadNotifications(GtdNotifySenderMethod.private);
      });
    });
  }

  Future<void> loadNotifications(GtdNotifySenderMethod senderMethod, {int page = 0}) async {
    emit(NotificationsLoading(senderMethod));
    if (userRefCode.isEmpty) {
      emit(NotificationsInitial(senderMethod));
      return;
    }
    GtdUtilityRepository.shared
        .getListNotifications(userRefcode: userRefCode, senderMethod: senderMethod, page: page)
        .then((value) {
      value.when((success) => emit(NotificationsInitial(senderMethod, notificationsRs: success)),
          (error) => emit(NotificationsInitial(senderMethod)));
    });
  }

  Future<void> loadMoreNotifications(GtdNotifySenderMethod senderMethod, {int page = 0}) async {
    emit(NotificationsLoadingMore(senderMethod));
    if (userRefCode.isEmpty) {
      emit(NotificationsInitial(senderMethod));
      return;
    }
    GtdUtilityRepository.shared
        .getListNotifications(userRefcode: userRefCode, senderMethod: senderMethod, page: page)
        .then((value) {
      value.when((success) => emit(NotificationsInitial(senderMethod, notificationsRs: success)),
          (error) => emit(NotificationsInitial(senderMethod)));
    });
  }
}
