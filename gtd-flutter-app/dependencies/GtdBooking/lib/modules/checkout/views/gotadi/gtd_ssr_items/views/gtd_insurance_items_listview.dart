import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';

import '../view_model/gtd_insurance_items_list_viewmodel.dart';

class GtdInsuranceItemListView extends BaseView<GtdInsuranceItemsListViewModel> {
  const GtdInsuranceItemListView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Card(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Column(),
          ),
        )
      ],
    );
  }
}
