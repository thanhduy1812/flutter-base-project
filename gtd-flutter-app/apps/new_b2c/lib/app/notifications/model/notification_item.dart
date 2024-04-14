import 'dart:convert';

import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/material.dart';
import 'package:gtd_repository/gtd_repository.dart';

enum NotificationRedirectType { url, bookingNumber }

class NotificationItem {
  final GtdNotificationItemRs itemRs;
  late bool isRead;
  bool isLoadingItem = false;

  NotificationItem({required this.itemRs}) {
    isRead = GtdNotifyUserStatus.findByValue(itemRs.isRead ?? "") == GtdNotifyUserStatus.read;
  }

  factory NotificationItem.loadingItem() {
    NotificationItem item = NotificationItem(itemRs: GtdNotificationItemRs());
    item.isLoadingItem = true;
    return item;
  }

  Widget get notifyIconFromType {
    GtdNotificationType notificationType = GtdNotificationType.findByValue(itemRs.messageType ?? "");

    switch (notificationType) {
      case GtdNotificationType.confirmedTicket:
        return DVTImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-combo.svg");
      case GtdNotificationType.checkinPrompt:
        return DVTImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-combo.svg");
      case GtdNotificationType.confirmedHold:
        return DVTImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-combo.svg");
      case GtdNotificationType.paymentConfirm:
        return DVTImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-system.svg");
      case GtdNotificationType.paymentPrompt:
        return DVTImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-system.svg");
      case GtdNotificationType.marketing:
        return DVTImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-promo.svg");
      default:
        return DVTImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-system.svg");
    }
  }
}

extension GtdNotificationItemRsHelper on GtdNotificationItemRs {
  ({NotificationRedirectType notifType, String value})? getRedirectTuple() {
    if (redirectUrl == null) {
      return null;
    }

    if (redirectUrl!.contains("booking-result")) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      var bookingNumberBase64 = redirectUrl!.split("/").last;
      String bookingNumber = stringToBase64.decode(bookingNumberBase64);
      return (notifType: NotificationRedirectType.bookingNumber, value: bookingNumber);
    }

    if (Uri.tryParse(redirectUrl!) != null) {
      var urlString = "";
      if (redirectUrl!.startsWith('http://') || redirectUrl!.startsWith('https://')) {
        urlString = redirectUrl!;
      } else {
        urlString = 'https://${redirectUrl!}';
      }
      return (notifType: NotificationRedirectType.url, value: Uri.tryParse(urlString).toString());
    }
    return (notifType: NotificationRedirectType.url, value: "");
  }
}
