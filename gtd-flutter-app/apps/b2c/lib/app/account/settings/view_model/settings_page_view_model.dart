import 'package:easy_localization/easy_localization.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/cache_helper/models/gtd_account_hive.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:rxdart/rxdart.dart';

class SettingsPageViewModel extends BasePageViewModel {
  SettingsPageViewModel() {
    title = 'account.settingsAndGeneralInfo'.tr();
    account = UserManager.shared.currentAccount;
  }

  final biometricLogInStream = BehaviorSubject<bool>.seeded(false);
  GtdAccountHive? account;
}