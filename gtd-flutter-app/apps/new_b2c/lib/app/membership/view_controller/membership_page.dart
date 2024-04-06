import 'package:flutter/widgets.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view/gtd_web_view/gtd_web_view_stack.dart';

class MembershipPage extends BaseStatelessPage {
  static const String route = '/membershipPage';
  const MembershipPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return const GtdWebViewStack(url: "https://www.gotadi.com/customer/member-ship");
  }
}
