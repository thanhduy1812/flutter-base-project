import 'package:flutter/material.dart';
import 'package:gtd_repository/app_repository/gtd_repositories/common_enum/gtd_final_booking_status.dart';
import 'package:path/path.dart' as p;

import 'image_extension.dart';

extension GTDAppIcon on Icon {
  static Widget iconNamedSupplier({
    required String iconName,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    String pathExtension = p.extension(iconName);
    if (pathExtension.toLowerCase() == ".svg") {
      return GTDImage.svgFromSupplier(
        assetName: "assets/icons/$iconName",
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      );
    } else {
      return GTDImage.imgFromSupplier(
        assetName: "assets/icons/$iconName",
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      );
    }
  }

  static Widget iconNamedCommon({required String iconName, double? width, double? height, BoxFit? fit}) {
    String pathExtension = p.extension(iconName);
    if (pathExtension.toLowerCase() == ".svg") {
      return GTDImage.svgFromCommon(
          assetName: "assets/icons/$iconName", width: width, height: height, fit: fit ?? BoxFit.contain);
    } else {
      return GTDImage.imgFromCommon(
          assetName: "assets/icons/$iconName", width: width, height: height, fit: fit ?? BoxFit.contain);
    }
  }

  static Widget get radioCircle {
    return GTDImage.svgFromSupplier(assetName: "assets/icons/radio/radio-circle.svg");
  }

  static Widget get radioCircleActive {
    return GTDImage.svgFromSupplier(assetName: "assets/icons/radio/radio-circle-active.svg");
  }

  static Widget get radioCheckbox {
    return GTDImage.svgFromSupplier(assetName: "assets/icons/radio/radio-checkbox.svg");
  }

  static Widget get radioCheckboxActive {
    return GTDImage.svgFromSupplier(assetName: "assets/icons/radio/radio-checkbox-active.svg");
  }

  static Widget iconBookingStatus({required DisplayBookingStatus status}) {
    switch (status) {
      case DisplayBookingStatus.success:
        return GTDImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-success.svg");
      case DisplayBookingStatus.failed:
        return GTDImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-failed.svg");
      case DisplayBookingStatus.pending:
        return GTDImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-pending.svg");
      case DisplayBookingStatus.booked:
        return GTDImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-booked.svg");
      default:
        return GTDImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-failed.svg");
    }
  }

  static Widget iconInsurance({required String status}) {
    return GTDImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-success.svg");
  }
}
