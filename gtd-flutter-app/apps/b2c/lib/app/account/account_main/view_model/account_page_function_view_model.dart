import 'package:gtd_utils/base/view_model/base_view_model.dart';

class AccountPageFunctionViewModel extends BaseViewModel {
  final String assetName;
  final String title;
  final bool marginBottom;

  AccountPageFunctionViewModel({
    required this.title,
    required this.assetName,
    this.marginBottom = false,
  });
}
