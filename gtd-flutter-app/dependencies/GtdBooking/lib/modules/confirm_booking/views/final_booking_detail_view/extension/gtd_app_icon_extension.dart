import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';

import '../view_model/final_booking_status_viewmodel.dart';

extension GTDBookingIcon on Icon {
  static Widget iconBookingStatus({required DisplayBookingStatus status}) {
    switch (status) {
      case DisplayBookingStatus.success:
        return GtdImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-success.svg");
      case DisplayBookingStatus.failed:
        return GtdImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-failed.svg");
      case DisplayBookingStatus.pending:
        return GtdImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-pending.svg");
      case DisplayBookingStatus.booked:
        return GtdImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-booked.svg");
      default:
        return GtdImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-failed.svg");
    }
  }

  static Widget iconInsurance({required String status}) {
    return GtdImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-success.svg");
  }
}
