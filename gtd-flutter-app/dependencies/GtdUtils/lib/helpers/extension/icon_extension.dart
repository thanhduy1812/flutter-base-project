// import 'package:flutter/material.dart';
// import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_final_booking_status.dart';
// import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';

extension GtdAppIcon on Icon {
  static Widget iconNamedSupplier({
    required String iconName,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    String pathExtension = p.extension(iconName);
    if (pathExtension.toLowerCase() == ".svg") {
      return GtdImage.svgFromSupplier(
        assetName: "assets/icons/$iconName",
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      );
    } else {
      return GtdImage.imgFromSupplier(
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
      return GtdImage.svgFromCommon(
          assetName: "assets/icons/$iconName", width: width, height: height, fit: fit ?? BoxFit.contain);
    } else {
      return GtdImage.imgFromCommon(
          assetName: "assets/icons/$iconName", width: width, height: height, fit: fit ?? BoxFit.contain);
    }
  }

  static Widget get radioCircle {
    return GtdImage.svgFromSupplier(assetName: "assets/icons/radio/radio-circle.svg");
  }

  static Widget get radioCircleActive {
    return GtdImage.svgFromSupplier(assetName: "assets/icons/radio/radio-circle-active.svg");
  }

  static Widget get radioCheckbox {
    return GtdImage.svgFromSupplier(assetName: "assets/icons/radio/radio-checkbox.svg");
  }

  static Widget get radioCheckboxActive {
    return GtdImage.svgFromSupplier(assetName: "assets/icons/radio/radio-checkbox-active.svg");
  }

  // static Widget iconBookingStatus({required DisplayBookingStatus status}) {
  //   switch (status) {
  //     case DisplayBookingStatus.success:
  //       return GtdImage.svgFromSupplier(
  //           assetName: "assets/icons/status/booking-status-success.svg");
  //     case DisplayBookingStatus.failed:
  //       return GtdImage.svgFromSupplier(
  //           assetName: "assets/icons/status/booking-status-failed.svg");
  //     case DisplayBookingStatus.pending:
  //       return GtdImage.svgFromSupplier(
  //           assetName: "assets/icons/status/booking-status-pending.svg");
  //     case DisplayBookingStatus.booked:
  //       return GtdImage.svgFromSupplier(
  //           assetName: "assets/icons/status/booking-status-booked.svg");
  //     default:
  //       return GtdImage.svgFromSupplier(
  //           assetName: "assets/icons/status/booking-status-failed.svg");
  //   }
  // }

  static Widget iconInsurance({required String status}) {
    return GtdImage.svgFromSupplier(assetName: "assets/icons/status/booking-status-success.svg");
  }
}

extension GtdImage on Image {
  static Image imgFromSupplier({required String assetName, double? width, double? height, BoxFit? fit}) {
    return DVTImage.imgFromSupplier(
        assetName: assetName, packageName: AppConst.shared.supplierResource, width: width, height: height, fit: fit);
  }

  static Widget svgFromSupplier(
      {required String assetName, double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}) {
    return DVTImage.svgFromSupplier(
        assetName: assetName,
        packageName: AppConst.shared.supplierResource,
        width: width,
        height: height,
        fit: fit,
        color: color);
  }

  static Image imgFromCommon({required String assetName, double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      GtdString.pathForAsset(AppConst.shared.commonResource, assetName),
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget svgFromCommon(
      {required String assetName, double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}) {
    return DVTImage.svgFromCommon(
        assetName: assetName,
        packageName: AppConst.shared.supplierResource,
        width: width,
        height: height,
        fit: fit,
        color: color);
  }

  static Image giftFromSupplier({required String assetName, BoxFit? boxFit}) {
    return Image.asset(
      GtdString.pathForAsset(AppConst.shared.supplierResource, assetName),
      gaplessPlayback: true,
      fit: boxFit,
    );
  }

  static Image giftFromCommon({required String assetName, BoxFit? boxFit}) {
    return Image.asset(
      GtdString.pathForAsset(AppConst.shared.commonResource, assetName),
      gaplessPlayback: true,
      fit: boxFit,
    );
  }

  static Image imgFromUrl(String url, {BoxFit boxFit = BoxFit.fitWidth}) {
    var img = Image.network(
      url,
      fit: boxFit,
    );
    return img;
  }

  static Widget svgFromUrl(String url, {BoxFit boxFit = BoxFit.fitWidth}) {
    return DVTImage.svgFromUrl(url, boxFit: boxFit);
  }

  static Widget cachedImgFromUrl(String url) {
    return DVTImage.cachedImgFromUrl(url);
  }

  static Widget cachedImgUrlWithPlaceholder({
    required String url,
    Widget? placeholder,
    Widget? errorWidget,
    BoxFit? fit,
  }) {
    return DVTImage.cachedImgUrlWithPlaceholder(url: url, placeholder: placeholder, errorWidget: errorWidget, fit: fit);
  }

  // static Image imgFromAsset({required String pathResource, double? width, double? height, BoxFit? fit, Color? color}) {
  //   return Image.asset(
  //     pathResource,
  //     width: width,
  //     height: height,
  //     color: color,
  //     fit: fit,
  //   );
  // }

  // static Widget svgFromAsset(
  //     {required String pathResource, double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}) {
  //   return SvgPicture.asset(
  //     pathResource,
  //     width: width,
  //     height: height,
  //     fit: fit,
  //     colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
  //   );
  // }

  //MARK: Using for Lottie Json from Adobe Effect or network
  static Widget assetAnimated(
      {required String assetName,
      double? width,
      double? height,
      BoxFit? fit,
      AnimationController? controller,
      bool? repeat,
      bool? reverse}) {
    return DVTImage.assetAnimated(
        assetName: assetName,
        packageName: AppConst.shared.supplierResource,
        width: width,
        height: height,
        fit: fit,
        controller: controller,
        repeat: repeat,
        reverse: reverse);
  }

  static Widget networkAnimated(
      {required String assetName,
      double? width,
      double? height,
      BoxFit? fit,
      AnimationController? controller,
      bool? repeat,
      bool? reverse}) {
    return DVTImage.networkAnimated(
        assetName: assetName,
        packageName: AppConst.shared.supplierResource,
        width: width,
        height: height,
        fit: fit,
        controller: controller,
        repeat: repeat,
        reverse: reverse);
  }
}
