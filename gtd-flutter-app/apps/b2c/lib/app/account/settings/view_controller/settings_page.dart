import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view/gtd_web_view/gtd_web_view_stack.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_review.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_switch.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';
import 'package:new_gotadi/app/account/change_password/change_password.dart';
import 'package:new_gotadi/app/account/settings/view_model/settings_page_view_model.dart';
import 'package:new_gotadi/app/router/gtd_b2c_router.dart';

class SettingsPage extends BaseStatelessPage<SettingsPageViewModel> {
  static const String route = '/settings';

  const SettingsPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return Column(
      children: [
        const SizedBox(height: 1),
        _SettingItem(
          title: 'account.settingsPage.aboutGotadi'.tr(),
          onTap: () {},
          marginBottom: 1,
        ),
        _SettingItem(
          title: 'account.settingsPage.termsAndConditions'.tr(),
          onTap: () => _showTermsAndConditions(pageContext),
          marginBottom: 1,
        ),
        _SettingItem(
          title: 'account.settingsPage.rateGotadi'.tr(),
          onTap: () => GtdReview().requestAppReview(),
          marginBottom: 16,
        ),
        if (viewModel.account != null)
          _SettingItem(
            title: 'account.settingsPage.changePassword'.tr(),
            onTap: () => pageContext.push(ChangePasswordPage.route),
            marginBottom: 16,
          ),
        _SettingItem(
          title: 'account.settingsPage.selectLanguage'.tr(),
          onTap: () {
            _showSelectLanguage(pageContext);
          },
          marginBottom: 1,
        ),
        if (viewModel.account != null) _biometricLogIn(pageContext),
      ],
    );
  }

  Widget _biometricLogIn(BuildContext pageContext) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'account.settingsPage.biometricLogIn'.tr(),
              style: TextStyle(
                fontSize: 15,
                color: GtdColors.inkBlack,
              ),
            ),
          ),
          StreamBuilder<bool>(
            stream: viewModel.biometricLogInStream,
            builder: (context, snapshot) {
              return GtdCustomSwitch(
                value: snapshot.data ?? false,
                activeToggleColor: Colors.white,
                activeToggleColorGradient: GtdColors.appGradient(pageContext),
                switchBorder: Border.all(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
                onToggle: (val) {
                  viewModel.biometricLogInStream.add(val);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  _showSelectLanguage(BuildContext pageContext) {
    GtdPresentViewHelper.presentSheet<String?>(
      title: 'account.settingsPage.selectLanguage'.tr(),
      context: pageContext,
      builder: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ['vi', 'en'].map((code) {
                return _SelectLanguageItem(
                  code: code,
                  onTap: () {
                    context.pop();
                    context.setLocale(
                      Locale.fromSubtags(languageCode: code),
                    );
                    CacheHelper.shared.cacheLanguage(code);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  _showTermsAndConditions(BuildContext pageContext) {
    GtdPresentViewHelper.presentView(
      context: rootContext ?? pageContext,
      title: 'account.settingsPage.termsAndConditions'.tr(),
      contentPadding: EdgeInsets.zero,
      enableDrag: false,
      hasInsetBottom: false,
      builder: Builder(
        builder: (context) {
          return const GtdWebViewStack(
            url: 'https://www.gotadi.com/customer/terms-conditions',
          );
        },
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double? marginBottom;

  const _SettingItem({
    required this.title,
    required this.onTap,
    this.marginBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: marginBottom ?? 0),
      child: GtdTapWidget(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: GtdColors.inkBlack,
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: Center(
                    child: GtdImage.svgFromSupplier(
                      assetName: 'assets/icons/down.svg',
                      color: GtdColors.appMainColor(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectLanguageItem extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const _SelectLanguageItem({
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GtdTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: GtdColors.snowGrey),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'account.settingsPage.$code'.tr(),
                style: TextStyle(
                  fontSize: 15,
                  color: GtdColors.inkBlack,
                ),
              ),
            ),
            GtdRadio(
              value: code,
              groupValue: context.locale.languageCode,
              selectedIcon: const GtdSimpleRadioWidget(
                size: 24,
                isSelected: true,
              ),
              unselectedIcon: const GtdSimpleRadioWidget(
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
