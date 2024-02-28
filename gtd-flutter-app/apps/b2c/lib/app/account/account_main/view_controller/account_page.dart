import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/invoice/view_controller/invoice_history_page.dart';
import 'package:gtd_booking/modules/my_booking/view_controller/gtd_my_booking_page.dart';
import 'package:gtd_booking/modules/personal_info/view_controller/saved_company_page.dart';
import 'package:gtd_booking/modules/personal_info/view_controller/saved_traveller_page.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';
import 'package:new_gotadi/app/account/account_main/account_main.dart';
import 'package:new_gotadi/app/account/log_in/log_in.dart';
import 'package:new_gotadi/app/account/settings/settings.dart';
import 'package:new_gotadi/app/membership/view_controller/membership_page.dart';
import 'package:new_gotadi/app/notifications/view_controller/notifications_page.dart';
import 'package:new_gotadi/app/router/gtd_b2c_router.dart';

class AccountPage extends BaseStatelessPage<AccountPageViewModel> {
  const AccountPage({
    super.key,
    required super.viewModel,
  });

  @override
  Widget buildBody(BuildContext pageContext) {
    viewModel.context = pageContext;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ColoredBox(
        color: GtdColors.winterWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _accountUser(),
            AccountFunctionRow(
              viewModel: viewModel.memberBenefitVM,
              onTap: () {
                pageContext.push(MembershipPage.route);
              },
            ),
            const SizedBox(height: 16),
            ..._accountFunctions(pageContext),
            const SizedBox(height: 16),
            ..._supportAndSettings(pageContext),
            _logOutSection(pageContext),
            const SizedBox(height: 16),
            _appVersion(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  ///Showing the pending widget or account user with avatar and full name
  ///listening to logged in stream
  Widget _accountUser() {
    return StreamBuilder<bool>(
      stream: UserManager.shared.isLoggedInStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return AccountUserWidget(
            viewModel: viewModel.accountUserViewModel(),
          );
        }
        return const _LogInPendingWidget();
      },
    );
  }

  ///Showing app version from AppConst
  Padding _appVersion() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'global.currentAppVersion'.tr(
            args: [AppConst.version],
          ),
          style: TextStyle(
            fontSize: 12,
            color: GtdColors.steelGrey,
          ),
        ));
  }

  ///Functions related to logged in account
  _accountFunctions(BuildContext context) {
    return [
      AccountFunctionRow(
        viewModel: viewModel.savedPassengersVM,
        onTap: () {
          context.push(SavedTravellerPage.route);
        },
      ),
      AccountFunctionRow(
        viewModel: viewModel.savedBusinessVM,
        onTap: () {
          context.push(SavedCompanyPage.route);
        },
      ),
      AccountFunctionRow(
        viewModel: viewModel.yourBookingVM,
        onTap: () {
          context.push(GtdMyBookingPage.route);
        },
      ),
      AccountFunctionRow(
        viewModel: viewModel.notificationVM,
        onTap: () {
          context.push(NotificationsPage.route);
        },
      ),
      AccountFunctionRow(
        viewModel: viewModel.receiptHistoryVM,
        onTap: () {
          context.push(InvoiceHistoryPage.route);
        },
      ),
    ];
  }

  _supportAndSettings(BuildContext context) {
    return [
      AccountFunctionRow(
        viewModel: viewModel.supportVM,
        onTap: () {
          GtdPresentViewHelper.presentSheet(
            context: rootContext ?? context,
            contentPadding: EdgeInsets.zero,
            title: 'account.quickSupport'.tr(),
            builder: Builder(
              builder: (context) {
                return const SupportBottomSheet();
              },
            ),
          );
        },
      ),
      AccountFunctionRow(
        viewModel: viewModel.contactAndFeedbackVM,
        onTap: () {
          GtdPresentViewHelper.presentSheet(
            context: rootContext ?? context,
            contentPadding: EdgeInsets.zero,
            title: 'account.contactAndFeedback'.tr(),
            builder: Builder(
              builder: (context) {
                return const ContactFeedbackBottomSheet();
              },
            ),
          );
        },
      ),
      AccountFunctionRow(
        viewModel: viewModel.settingsAndGeneralInfoVM,
        onTap: () => context.push(SettingsPage.route),
      ),
    ];
  }

  _logOutWidget(BuildContext context) {
    return AccountFunctionRow(
      viewModel: viewModel.logOutVM,
      onTap: () => viewModel.onLogOutTap(),
    );
  }

  ///Log out section - with spacing and
  ///stream to listen to authentication changes
  _logOutSection(BuildContext context) {
    return StreamBuilder(
      stream: UserManager.shared.isLoggedInStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Column(
            children: [
              const SizedBox(height: 16),
              _logOutWidget(context),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

///Widget showing log in/sign up
class _LogInPendingWidget extends StatelessWidget {
  const _LogInPendingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: GtdTapWidget(
        backgroundColor: Colors.white,
        onTap: () {
          context.push(LogInPage.route);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _placeholderAvatar(),
              const SizedBox(width: 12),
              _textsColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Column _textsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'account.logInOrSignUp'.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'account.logInDescription'.tr(),
          style: TextStyle(
            fontSize: 14,
            color: GtdColors.steelGrey,
          ),
        ),
      ],
    );
  }

  Container _placeholderAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: GtdColors.cloudyGrey,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GtdImage.imgFromSupplier(
          assetName: 'assets/images/avatar_placeholder.png',
        ),
      ),
    );
  }
}
