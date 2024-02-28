import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:new_gotadi/app/account/account_edit/account_edit.dart';
import 'package:new_gotadi/app/account/account_main/account_main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AccountEditPage extends BaseStatelessPage<AccountEditPageViewModel> {
  static const String route = '/account-edit';

  const AccountEditPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    viewModel.context = pageContext;
    return KeyboardDismisser(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ReactiveForm(
          formGroup: viewModel.form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: UserCircularAvatar(
                    avatarImage: viewModel.account?.avatarImage ?? '',
                  ),
                ),
                const SizedBox(height: 4),
                _changeAvatar(),
                const SizedBox(height: 8),
                _SectionTitle(
                  title: 'account.accountEditPage.yourInfo'.tr(),
                ),
                _infoSection(pageContext),
                _SectionTitle(
                  title: 'account.accountEditPage.paperworkInfo'.tr(),
                ),
                _passportSection(pageContext),
                _SectionTitle(
                  title: 'account.accountEditPage.memberAccount'.tr(),
                ),
                _memberAccountSection(),
                const SizedBox(height: 8),
                _deleteAccount(pageContext),
                const SizedBox(height: 12),
                _actionButtons(pageContext),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _actionButtons(BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        children: [
          Expanded(
            child: GtdButton(
              isEnable: true,
              onPressed: (value) {},
              text: 'global.delete'.tr(),
              colorText: GtdColors.inkBlack,
              fontSize: 16,
              height: 48,
              borderRadius: 24,
              border: Border.all(
                width: 2,
                color: GtdColors.blueGrey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GtdButton(
              isEnable: true,
              onPressed: (value) {
                viewModel.submitUpdate();
              },
              text: 'global.saveChange'.tr(),
              colorText: Colors.white,
              color: GtdColors.appMainColor(pageContext),
              fontSize: 16,
              height: 48,
              borderRadius: 24,
              border: Border.all(
                color: GtdColors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deleteAccount(BuildContext context) {
    return GtdTapWidget(
      onTap: () {
        GtdPopupMessage.showPopUpWithIcon(
          context: context,
          title: 'account.accountEditPage.deleteAccount.title'.tr(),
          description: 'account.accountEditPage.deleteAccount.message'.tr(),
          confirmText: 'account.accountEditPage.deleteAccount.confirm'.tr(),
          subtitle: 'account.accountEditPage.deleteAccount.confirmMessage'.tr(),
          cancelText: 'global.cancel'.tr(),
          iconAssetPath: 'assets/icons/warning-triangle.svg',
          onConfirm: () {},
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Center(
                child: GtdImage.svgFromSupplier(
                  assetName: 'assets/icons/trash.svg',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'account.accountEditPage.deleteAccount.title'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: GtdColors.inkBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _SectionContainer _memberAccountSection() {
    return _SectionContainer(
      child: Column(
        children: [
          AccountEditInput(
            fieldName: AccountEditFieldNames.memberAccountType,
            onTap: () {},
          ),
          const AccountEditInput(
            fieldName: AccountEditFieldNames.memberAccountNumber,
          ),
        ],
      ),
    );
  }

  _SectionContainer _passportSection(BuildContext context) {
    return _SectionContainer(
      child: Column(
        children: [
          const AccountEditInput(
            fieldName: AccountEditFieldNames.passportNumber,
          ),
          AccountEditInput(
            fieldName: AccountEditFieldNames.passportCountry,
            onTap: () {},
          ),
          AccountEditInput(
            fieldName: AccountEditFieldNames.passportExpireDate,
            onTap: () => viewModel.selectExpireDate(),
          ),
        ],
      ),
    );
  }

  _SectionContainer _infoSection(BuildContext context) {
    return _SectionContainer(
      child: Column(
        children: [
          _genderSelection(),
          const AccountEditInput(
            fieldName: AccountEditFieldNames.lastName,
          ),
          const AccountEditInput(
            fieldName: AccountEditFieldNames.firstName,
          ),
          AccountEditInput(
            fieldName: AccountEditFieldNames.dateOfBirth,
            onTap: () => viewModel.selectDOB(),
          ),
          AccountEditInput(
            fieldName: AccountEditFieldNames.nationality,
            onTap: () {},
          ),
          const AccountEditInput(
            fieldName: AccountEditFieldNames.email,
          ),
        ],
      ),
    );
  }

  Widget _changeAvatar() {
    return Center(
      child: GtdTapWidget(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Center(
                  child: GtdImage.svgFromSupplier(
                    assetName: 'assets/icons/edit-green.svg',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'account.accountEditPage.changeAvatar'.tr(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: GtdColors.inkBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _genderSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: GtdColors.snowGrey),
        ),
      ),
      child: StreamBuilder<GenderValueEnum>(
        stream: viewModel.genderStream,
        builder: (context, snapshot) {
          return Row(
            children: [
              _GenderRadio(
                gender: GenderValueEnum.male,
                groupValue: snapshot.data ?? GenderValueEnum.male,
                onChange: () {
                  viewModel.genderStream.add(GenderValueEnum.male);
                },
              ),
              const SizedBox(width: 16),
              _GenderRadio(
                gender: GenderValueEnum.female,
                groupValue: snapshot.data ?? GenderValueEnum.male,
                onChange: () {
                  viewModel.genderStream.add(GenderValueEnum.female);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: GtdColors.inkBlack,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _GenderRadio extends StatelessWidget {
  final GenderValueEnum gender;
  final GenderValueEnum groupValue;
  final VoidCallback onChange;

  const _GenderRadio({
    required this.gender,
    required this.groupValue,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return GtdTapWidget(
      onTap: onChange,
      child: Row(
        children: [
          AbsorbPointer(
            child: GtdRadio(
              selectedIcon: const GtdSimpleRadioWidget(
                size: 24,
                isSelected: true,
              ),
              unselectedIcon: const GtdSimpleRadioWidget(
                size: 24,
                isSelected: false,
              ),
              value: gender,
              groupValue: groupValue,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            gender.title(),
            style: TextStyle(
              fontSize: 16,
              color: GtdColors.inkBlack,
            ),
          )
        ],
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  final Widget child;

  const _SectionContainer({
    required this.child,
  });

  static final BoxDecoration _sectionDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _sectionDecoration,
      child: child,
    );
  }
}
