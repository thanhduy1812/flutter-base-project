import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/material.dart';
import 'package:gtd_repository/app_repository/app_config/app_const.dart';

extension GTDImage on Image {
  static Image imgFromSupplier({required String assetName, double? width, double? height, BoxFit? fit}) {
    return DVTImage.imgFromSupplier(
        assetName: assetName,
        packageName: (GTDAppConst.shared.supplierResource),
        width: width,
        height: height,
        fit: fit);
  }

  static Widget svgFromSupplier(
      {required String assetName, double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}) {
    return DVTImage.svgFromSupplier(
        assetName: assetName,
        packageName: GtdString.pathForAsset(GTDAppConst.shared.supplierResource, assetName),
        width: width,
        height: height,
        fit: fit,
        color: color);
  }

  static Image imgFromCommon({required String assetName, double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      GtdString.pathForAsset(GTDAppConst.shared.commonResource, assetName),
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget svgFromCommon(
      {required String assetName, double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}) {
    return DVTImage.svgFromCommon(
        assetName: assetName,
        packageName: GtdString.pathForAsset(GTDAppConst.shared.supplierResource, assetName),
        width: width,
        height: height,
        fit: fit,
        color: color);
  }

  static Image giftFromSupplier({required String assetName, BoxFit? boxFit}) {
    return Image.asset(
      GtdString.pathForAsset(GTDAppConst.shared.supplierResource, assetName),
      gaplessPlayback: true,
      fit: boxFit,
    );
  }

  static Image giftFromCommon({required String assetName, BoxFit? boxFit}) {
    return Image.asset(
      GtdString.pathForAsset(GTDAppConst.shared.commonResource, assetName),
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
        packageName: GtdString.pathForAsset(GTDAppConst.shared.supplierResource, assetName),
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
        packageName: GtdString.pathForAsset(GTDAppConst.shared.supplierResource, assetName),
        width: width,
        height: height,
        fit: fit,
        controller: controller,
        repeat: repeat,
        reverse: reverse);
  }
}
