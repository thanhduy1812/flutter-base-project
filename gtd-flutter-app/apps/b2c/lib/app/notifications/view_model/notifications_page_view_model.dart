import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/utility_resource/utility_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_model/gtd_paging_dto.dart';
import 'package:new_gotadi/app/notifications/model/notification_item.dart';

class NotificationsPageViewModel extends BasePageViewModel {
  String userRefCode = "";
  GtdNotifySenderMethod selectedSenderMethod = GtdNotifySenderMethod.private;
  bool isFirstLoadPrivate = false;
  bool isFirstLoadBroadcast = false;

  GtdPagingDTO<NotificationItem> privateNotifications = GtdPagingDTO(data: []);
  GtdPagingDTO<NotificationItem> broadcastNotifications = GtdPagingDTO(data: []);
  List<NotificationItem> loadingItems = Iterable<int>.generate(4).map((e) => NotificationItem.loadingItem()).toList();
  NotificationsPageViewModel() {
    title = "Thông báo";
  }

  GtdPagingDTO<NotificationItem> currentListSender(GtdNotifySenderMethod senderMethod) {
    if (senderMethod == GtdNotifySenderMethod.broadcast) {
      return broadcastNotifications;
    }
    return privateNotifications;
  }

  void updateListNotificationsBySender(GtdNotificationsRs notificationsRs, GtdNotifySenderMethod senderMethod) {
    finishLoading(senderMethod);
    var items = (notificationsRs.content ?? []).map((e) => NotificationItem(itemRs: e)).toList();
    var currentList = currentListSender(senderMethod);
    //Avoid add duplicate if same page
    if ((currentList.page == notificationsRs.pageable?.pageNumber && currentList.page != 0) ||
        (notificationsRs.content?.firstOrNull?.senderMethod != senderMethod.rawValue)) {
      return;
    }
    currentList.page = notificationsRs.pageable?.pageNumber ?? 0;
    currentList.totalPage = notificationsRs.totalPages ?? 0;
    if (items.firstOrNull?.itemRs.senderMethod == senderMethod.rawValue) {
      // currentListSender(senderMethod).data = [...currentList.data, ...items];
      currentList.data.addAll(items);
    }
  }

  void addLoading(GtdNotifySenderMethod senderMethod) {
    var currentList = currentListSender(senderMethod);
    currentList.data.addAll(loadingItems);
  }

  void finishLoading(GtdNotifySenderMethod senderMethod) {
    var currentList = currentListSender(senderMethod);
    currentList.data.removeWhere((element) => element.isLoadingItem);
  }

  void updateFirstLoad(GtdNotifySenderMethod senderMethod) {
    if (senderMethod == GtdNotifySenderMethod.private) {
      isFirstLoadPrivate = true;
    }
    if (senderMethod == GtdNotifySenderMethod.broadcast) {
      isFirstLoadBroadcast = true;
    }
  }

  bool firstLoadState(GtdNotifySenderMethod senderMethod) {
    if (senderMethod == GtdNotifySenderMethod.private) {
      return isFirstLoadPrivate;
    }
    return isFirstLoadBroadcast;
  }

  void resetItems() {
    var currentList = currentListSender(selectedSenderMethod);
    currentList.page = 0;
    currentList.totalPage = 0;
    currentList.data = [];
  }
}
