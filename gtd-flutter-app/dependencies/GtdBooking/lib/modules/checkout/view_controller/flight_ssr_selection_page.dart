import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/insurance_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/insurance_view/view/insurance_view.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';

import '../cubit/flight_ssr_selection_cubit.dart';
import '../view_model/flight_ssr_selection_page_viewmodel.dart';
import '../views/gotadi/gtd_ssr_items/view_model/gtd_ssr_items_list_viewmodel.dart';
import '../views/gotadi/gtd_ssr_items/views/gtd_ssr_items_listview.dart';

class FlightSSRSelectionPage extends PricingBottomPage<FlightSSRSelectionPageViewModel> {
  static const String route = "/flightSSRSelectionPage";
  const FlightSSRSelectionPage({super.key, required super.viewModel});

  @override
  List<Tab> get tabs => viewModel.tabTitles
      .map((e) => Tab(
            text: e,
          ))
      .toList();

  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    viewModel.title = viewModel.title;
    return super.buildAppbar(pageContext);
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => FlightSsrSelectionCubit(),
      child: BlocBuilder<FlightSsrSelectionCubit, FlightSsrSelectionState>(
        builder: (selectSSRContext, selectSSRState) {
          if (viewModel.serviceType == ServiceType.insurance) {
            return TabBarView(children: [buildInsuranceListView(selectSSRContext)]);
          } else {
            return TabBarView(children: viewModel.ssrItemLisviewModels.map((e) => buildSSRContent(e)).toList());
          }
        },
      ),
    );
  }

  Widget buildSSRContent(GtdSSRItemListViewModel itemListViewModel) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                IntrinsicWidth(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(itemListViewModel.locationTitle,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                    subtitle: Text(itemListViewModel.operationAirlineTitle,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    itemListViewModel.totalSsrAmount,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.currencyText),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: (switch (itemListViewModel.initialSSRItems.isEmpty) {
                    true => const SizedBox(
                        height: 400,
                        child: Center(
                          child: Text("No items"),
                        ),
                      ),
                    false => Card(
                        elevation: 0,
                        color: Colors.white,
                        child: GtdSSRItemListView(viewModel: itemListViewModel),
                      ),
                  }),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 50))
            ],
          ))
        ],
      ),
    );
  }

  Widget buildInsuranceListView(BuildContext context) {
    return BlocProvider(
      create: (insuranceContext) => InsuranceCubit(),
      child: BlocBuilder<InsuranceCubit, InsuranceState>(
        builder: (insuranceContext, state) {
          if (state is InsurancePlanLoaded) {
            viewModel.insuranceViewModels.map((e) => e.updatePackageFlexi(state.insurancePlans)).toList();
          }
          return CustomScrollView(
            slivers: [
              SliverList.separated(
                itemCount: viewModel.insuranceViewModels.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InsuranceView(
                      viewModel: viewModel.insuranceViewModels[index],
                      onSelect: (value) {
                        viewModel.selectedFlexiItem = value.selectedValue;
                        BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                      },
                      onChangePackage: (value) {
                        BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidgetUnique(value);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
