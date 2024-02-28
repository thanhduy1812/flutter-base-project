import 'package:gtd_utils/base/view_model/base_view_model.dart';

class AccountUserViewModel extends BaseViewModel {
  final String fullName;
  final String avatarUrl;
  final String membershipClass;

  AccountUserViewModel({
    required this.fullName,
    required this.avatarUrl,
    required this.membershipClass,
  });
}
