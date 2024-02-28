// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/string_extension.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:new_gotadi/app/account/account_main/account_main.dart';

class AccountPageViewModel extends BasePageViewModel {
  late BuildContext context;

  AccountPageViewModel() {
    title = 'global.account'.tr();
    backgroundColor = GtdColors.winterWhite;
  }

  AccountPageFunctionViewModel memberBenefitVM = AccountPageFunctionViewModel(
    title: 'account.memberBenefit'.tr(),
    assetName: 'assets/icons/member-benefit.svg',
  );

  AccountPageFunctionViewModel savedPassengersVM = AccountPageFunctionViewModel(
    title: 'account.savedPassengers'.tr(),
    assetName: 'assets/icons/address-book.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel savedBusinessVM = AccountPageFunctionViewModel(
    title: 'account.savedBusiness'.tr(),
    assetName: 'assets/icons/saved-business.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel yourBookingVM = AccountPageFunctionViewModel(
    title: 'account.yourBooking'.tr(),
    assetName: 'assets/icons/your-booking.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel notificationVM = AccountPageFunctionViewModel(
    title: 'account.notification'.tr(),
    assetName: 'assets/icons/notification-bell.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel receiptHistoryVM = AccountPageFunctionViewModel(
    title: 'account.receiptHistory'.tr(),
    assetName: 'assets/icons/list-invoice.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel supportVM = AccountPageFunctionViewModel(
    title: 'account.support'.tr(),
    assetName: 'assets/icons/support.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel contactAndFeedbackVM = AccountPageFunctionViewModel(
    title: 'account.contactAndFeedback'.tr(),
    assetName: 'assets/icons/mail.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel settingsAndGeneralInfoVM = AccountPageFunctionViewModel(
    title: 'account.settingsAndGeneralInfo'.tr(),
    assetName: 'assets/icons/settings.svg',
    marginBottom: true,
  );

  AccountPageFunctionViewModel logOutVM = AccountPageFunctionViewModel(
    title: 'account.logOut'.tr(),
    assetName: 'assets/icons/log-out.svg',
    marginBottom: true,
  );

  ///Tapped on log out
  onLogOutTap() {
    GtdPopupMessage.confirmPopUp(
      context: context,
      title: 'account.logOut'.tr(),
      description: 'account.logOutConfirmMessage'.tr(),
      cancelText: 'global.cancel'.tr(),
      confirmText: 'account.logOut'.tr(),
      onConfirm: () {
        _processLogOut();
      },
    );
  }

  AccountUserViewModel accountUserViewModel() {
    final accountData = UserManager.shared.currentAccount;
    return AccountUserViewModel(
      fullName: '${accountData?.lastName} ${accountData?.firstName} ',
      avatarUrl: accountData?.avatarImage ?? '',
      membershipClass: (accountData?.membershipClass ?? '').capitalize(),
    );
  }

  ///Process to request log out when user confirms
  _processLogOut() async {
    GtdLoading.show();
    final response = await GtdAuthenticationRepository.shared.logOut();
    GtdLoading.hide();
    response.when((success) {
      ///Remove account and token data from local preferences
      _removeLogInData();
    }, (error) {
      _removeLogInData();
      // GtdPopupMessage(context).showError(
      //   title: 'account.notification'.tr(),
      //   error: error.message,
      // );
    });
  }

  _removeLogInData() async {
    GtdChannelSettingObject.shared.token = null;
    CacheHelper.shared.removeUserCache();
    UserManager.shared.setLoggedIn(false);
    await UserManager.shared.removeAccountData();
  }
}
