
import 'package:flutter/material.dart';
import 'package:gtd_repository/gtd_repository.dart';

import '../view_model/final_booking_status_viewmodel.dart';

extension GTDBookingIcon on Icon {
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