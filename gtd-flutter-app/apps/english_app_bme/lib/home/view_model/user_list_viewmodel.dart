// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';

class UserListViewModel extends BaseViewModel {
  List<BmeUser> bmeUsers = [];
  UserListViewModel({
    this.bmeUsers = const [],
  });
}
