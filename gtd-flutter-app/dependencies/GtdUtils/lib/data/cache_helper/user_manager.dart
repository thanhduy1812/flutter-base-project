import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/cache_helper/models/gtd_account_hive.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
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
    await CacheHelper.cacheObject<GtdAccountHive>(
      accountData,
      cacheStorageType: CacheStorageType.accountBox,
    );
    await getAccountData();
  }

  Future<GtdAccountHive?> getAccountData() async {
    final account = await CacheHelper.getCachedObject<GtdAccountHive>(
      cacheStorageType: CacheStorageType.accountBox,
    );
    _currentAccount = account;
    return _currentAccount;
  }

  Future<void> removeAccountData() async {
    await CacheHelper.deleteKeyCached(
      cacheStorageType: CacheStorageType.accountBox,
    );
  }
}
