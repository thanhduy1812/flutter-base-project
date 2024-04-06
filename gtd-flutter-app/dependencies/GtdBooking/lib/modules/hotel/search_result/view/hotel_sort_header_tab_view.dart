import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_sort_header_tab_viewmode.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_tabbar/view/gtd_tabbar_helper.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';

class HotelSortHeaderTabView extends BaseView<HotelSortHeaderTabViewModel> {
  const HotelSortHeaderTabView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return buildGotadiSortList(context);
  }

  Widget buildGotadiSortList(BuildContext hotelSortContext) {
    // var sorts = ["Đề xuất", "Giá thấp nhất", "Xếp hạng sao"];
    var sorts = viewModel.sortOptions;
    var parentViewModel = hotelSortContext.viewModelOf<HotelSearchResultPageViewModel>();
    var tabs = sorts
        .mapIndexed(
          (index, e) => Builder(builder: (context) {
            return InkWell(
              onTap: () {
                TabController tabController = DefaultTabController.of(context);
                if (tabController.index != index) {
                  DefaultTabController.of(context).animateTo(index);
                  var selectedSort = e;
                  if (parentViewModel != null) {
                    parentViewModel.hotelSearchRq.sortField = selectedSort.sortField;
                    parentViewModel.hotelSearchRq.sortOrder = selectedSort.sortOrder;
                    BlocProvider.of<HotelSearchCubit>(hotelSortContext)
                        .searchHotelBestRateWithSort(parentViewModel.hotelSearchRq.toMap());
                  }
                }
              },
              child: Tab(
                text: e.title,
              ),
            );
          }),
        )
        .toList();

    TabBar tabBar = GtdTabbarHelper.buildGotadiTabbar(tabs: tabs, isScrollable: true);
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: DefaultTabController(
            length: tabs.length,
            child: Builder(
              builder: (tabContext) {
                return PreferredSize(preferredSize: tabBar.preferredSize, child: tabBar);
              },
            )),
      ),
    );
  }
}
