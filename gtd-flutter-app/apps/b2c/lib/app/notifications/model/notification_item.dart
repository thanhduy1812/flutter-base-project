import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/utility_resource/utility_resource.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

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
        return GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-combo.svg");
      case GtdNotificationType.checkinPrompt:
        return GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-combo.svg");
      case GtdNotificationType.confirmedHold:
        return GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-combo.svg");
      case GtdNotificationType.paymentConfirm:
        return GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-system.svg");
      case GtdNotificationType.paymentPrompt:
        return GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-system.svg");
      case GtdNotificationType.marketing:
        return GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-promo.svg");
      default:
        return GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-system.svg");
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
