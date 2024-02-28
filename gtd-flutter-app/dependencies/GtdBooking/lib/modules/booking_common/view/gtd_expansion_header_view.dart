import 'package:flutter/material.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

class GtdExpansionHeaderView extends StatelessWidget {
  final bool isExpand;
  final String titleHeader;
  final Widget? collapsedView;
  final GtdVoidCallback? onTapHeader;
  final bool showExpandIcon;

  const GtdExpansionHeaderView({
    super.key,
    required this.isExpand,
    this.collapsedView,
    required this.titleHeader,
    this.onTapHeader,
    this.showExpandIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapHeader,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  titleHeader,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.boldText,
                      fontSize: 15),
                ),
              ),
              if (showExpandIcon)
                GtdAppIcon.iconNamedSupplier(
                  iconName:
                      "hotel/${isExpand ? "hotel-double-arrow-up" : "hotel-double-arrow-down"}.svg",
                ),
            ],
          ),
          collapsedView ?? const SizedBox(),
        ],
      ),
    );
  }
}
