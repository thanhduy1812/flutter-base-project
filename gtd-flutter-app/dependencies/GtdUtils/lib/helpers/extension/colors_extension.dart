import 'package:flutter/material.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/color_status.dart';

extension GtdColors on Colors {
  static LinearGradient appGradient(BuildContext context) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.1, 1],
        colors: [
          Theme.of(context).extension<GtdAppGradientColor>()?.startColor ?? AppColors.buttonColor,
          Theme.of(context).extension<GtdAppGradientColor>()?.endColor ?? AppColors.buttonColor
        ],
      );
  static Color appMainColor(BuildContext context) => Theme.of(context).colorScheme.primary;
}
