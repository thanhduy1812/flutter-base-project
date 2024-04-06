import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFeedbackBottomSheet extends StatelessWidget {
  const ContactFeedbackBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 150),
      child: Column(
        children: [
          _ContactFeedbackItem(
            assetPath: 'assets/icons/icon-clock-grey.svg',
            title: 'account.contactFeedbackContent.supportTime'.tr(),
            content: 'account.contactFeedbackContent.supportTimeContent'.tr(),
          ),
          _ContactFeedbackItem(
            assetPath: 'assets/icons/phone-call.svg',
            title: 'account.contactFeedbackContent.hotline1'.tr(),
            content: 'account.contactFeedbackContent.support247'.tr(),
          ),
          _ContactFeedbackItem(
            assetPath: 'assets/icons/phone-call.svg',
            title: 'account.contactFeedbackContent.hotline2'.tr(),
            content: 'account.contactFeedbackContent.support247'.tr(),
            bigDivider: true,
          ),
          _ContactFeedbackItem(
            assetPath: 'assets/icons/location-pin.svg',
            title: 'account.contactFeedbackContent.hcmOffice'.tr(),
            content: 'account.contactFeedbackContent.hcmOfficeInfo'.tr(),
            bigDivider: true,
          ),
          _ContactFeedbackItem(
            assetPath: 'assets/icons/location-pin.svg',
            title: 'account.contactFeedbackContent.hnOffice'.tr(),
            content: 'account.contactFeedbackContent.hnOfficeInfo'.tr(),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ContactFeedbackItem extends StatelessWidget {
  final String assetPath;
  final String title;
  final String content;
  final bool bigDivider;
  final bool showDivider;

  const _ContactFeedbackItem({
    required this.assetPath,
    required this.title,
    required this.content,
    this.bigDivider = false,
    this.showDivider = true,
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
                  width: 40,
                  height: 40,
                  child: Center(
                    child: GtdImage.svgFromSupplier(
                      assetName: assetPath,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: GtdColors.inkBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 13,
                          color: GtdColors.steelGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showDivider) Divider(
            color: GtdColors.snowGrey,
            thickness: bigDivider ? 8 : 1,
          ),
        ],
      ),
    );
  }
}
