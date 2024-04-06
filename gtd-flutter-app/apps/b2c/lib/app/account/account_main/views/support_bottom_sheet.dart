import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportBottomSheet extends StatelessWidget {
  const SupportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        children: [
          _SupportItem(
            assetPath: 'assets/icons/phone-call.svg',
            title: 'account.supportMethods.phone'.tr(),
          ),
          _SupportItem(
            assetPath: 'assets/icons/zalo.svg',
            title: 'account.supportMethods.zalo'.tr(),
          ),
          _SupportItem(
            assetPath: 'assets/icons/facebook.svg',
            title: 'account.supportMethods.facebook'.tr(),
          ),
        ],
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final String assetPath;
  final String title;

  const _SupportItem({
    required this.assetPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GtdTapWidget(
      onTap: () {
        launchUrl(
          Uri.parse('fb://page/gotadi.travel'),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: GtdImage.svgFromSupplier(
                      assetName: assetPath,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: GtdColors.inkBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: GtdColors.snowGrey,
          ),
        ],
      ),
    );
  }
}
