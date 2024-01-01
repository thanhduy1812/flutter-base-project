// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'kredivo_option_vm.dart';

class KredivoLoadViewModel extends BaseViewModel {
  String bookingNumber;
  List<KredivoOptionVM> kredivoOtions = const [];
  KredivoLoadViewModel({
    required this.bookingNumber,
  });
}
