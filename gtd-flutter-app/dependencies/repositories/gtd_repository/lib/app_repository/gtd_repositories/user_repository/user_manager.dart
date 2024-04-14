import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/app_repository/gtd_repositories/common_enum/models/gtd_account_hive.dart';
import 'package:rxdart/rxdart.dart';

class UserManager {
  UserManager._() {
    if (token.isNotEmpty) {
      isLoggedInStream.add(true);
    }
  }

  String get token => CacheHelper.shared.getCachedAppToken();
  static final shared = UserManager._();
  final isLoggedInStream = BehaviorSubject<bool>.seeded(false);
  late GtdCallback<String> bookingResultWebViewCallback;
  late GtdVoidCallback popToHomeCallback;

  GtdAccountHive? _currentAccount;

  GtdAccountHive? get currentAccount => _currentAccount;

  setLoggedIn(bool isLoggedIn) {
    isLoggedInStream.add(isLoggedIn);
  }

  Future<void> cacheUserData(GtdAccountHive accountData) async {
    // await CacheHelper.cacheObject<GtdAccountHive>(
    //   accountData,
    //   cacheStorageType: CacheStorageType.accountBox,
    // );
    await CacheHelper.shared.saveSharedObject(accountData.toMap(), key: CacheStorageType.accountBox.name);
    await getAccountData();
  }

  Future<GtdAccountHive?> getAccountData() async {
    final account = CacheHelper.shared.loadSavedObject(GtdAccountHive.fromMap, key: CacheStorageType.accountBox.name);
    _currentAccount = account;
    return _currentAccount;
  }

  Future<void> removeAccountData() async {
    CacheHelper.shared.removeCachedSharedObject(CacheStorageType.accountBox.name);
  }
}
