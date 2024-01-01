library dialog_itinerary;

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_search_cubit.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_search_state.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/flight_search_result_page_viewmodel.dart';
import 'package:gtd_utils/base/view/gtd_tabbar/view/gtd_tabbar_helper.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/models/request/filter_availability_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/sort_value.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button_radio.dart';

typedef OnTapCallback = void Function(int newValue);

// ignore: must_be_immutable
class FlightSortComponent extends StatelessWidget with ChangeNotifier {
  final OnTapCallback? onPressed;
  final FlightDirection flightDirection;
  FlightSortComponent({super.key, this.onPressed, required this.flightDirection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightSearchCubit, FlightSearchState>(builder: (flightSearchContext, flightSearchState) {
      if (AppConst.shared.appScheme.appSupplier == GtdAppSupplier.vib) {
        return SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: BlocBuilder<FlightSearchCubit, FlightSearchState>(builder: (flightSearchContext, flightSearchState) {
              return buildVibSortList(flightSearchContext);
            }),
          ),
        ));
      } else {
        return buildGotadiSortList(flightSearchContext);
      }
    });
  }

  Widget buildVibSortList(BuildContext flightSearchContext) {
    var parentViewModel = flightSearchContext.viewModelOf<FlightSearchResultPageViewModel>();
    GtdFlightSearchResultDTO flightSearchResultDTO = parentViewModel!.flightSearchResultDTO;
    FilterAvailabilityRq? filterAvailability = flightDirection == FlightDirection.d
        ? flightSearchResultDTO.departureItinerary?.filterOptions
        : flightSearchResultDTO.returnItinerary?.filterOptions;
    return Wrap(
        spacing: 0,
        children: FlightSortValue.values
            .map(
              (sort) => GtdButtonRadio(
                  text: 'flight.filter'.tr(gender: sort.name),
                  value: sort,
                  borderRadius: BorderRadius.zero,
                  type: GtdButtonRadioType.underline,
                  groupValue: filterAvailability?.sort ?? FlightSortValue.departureDateAsc,
                  isLoading: false,
                  onChanged: (selectedSort) async {
                    parentViewModel.filterAvailabilityRq.sort = selectedSort;
                    parentViewModel.refresh();

                    BlocProvider.of<FlightSearchCubit>(flightSearchContext).sortFLights(
                        filterAvailabilityRq: parentViewModel.filterAvailabilityRq,
                        flightDirection: parentViewModel.flightDirection,
                        flightSearchResultDTO: parentViewModel.flightSearchResultDTO);
                  }),
            )
            .toList());
  }

  Widget buildGotadiSortList(BuildContext flightSearchContext) {
    var parentViewModel = flightSearchContext.viewModelOf<FlightSearchResultPageViewModel>();
    var sorts = FlightSortValue.values;
    var tabs = sorts
        .mapIndexed(
          (index, e) => Builder(builder: (context) {
            return InkWell(
              onTap: () {
                TabController tabController = DefaultTabController.of(context);
                if (tabController.index != index) {
                  DefaultTabController.of(context).animateTo(index);
                  var selectedSort = e;
                  parentViewModel!.filterAvailabilityRq.sort = selectedSort;
                  parentViewModel.refresh();

                  BlocProvider.of<FlightSearchCubit>(flightSearchContext).sortFLights(
                      filterAvailabilityRq: parentViewModel.filterAvailabilityRq,
                      flightDirection: parentViewModel.flightDirection,
                      flightSearchResultDTO: parentViewModel.flightSearchResultDTO);
                }
              },
              child: Tab(
                text: 'flight.filter'.tr(gender: e.name),
              ),
            );
          }),
        )
        .toList();

    TabBar tabBar = GtdTabbarHelper.buildGotadiTabbar(tabs: tabs, isScrollable: true);
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        child: IntrinsicWidth(
          child: DefaultTabController(
            length: tabs.length,
            child: Builder(
              builder: (tabContext) {
                // TabController tabController = DefaultTabController.of(tabContext);
                // tabController.removeListener(() {});
                // if (!tabController.hasListeners) {
                //   tabController.addListener(() {
                //     if (!tabController.indexIsChanging) {
                //       var selectedSort = sorts[tabController.index];
                //       parentViewModel!.filterAvailabilityRq.sort = selectedSort;
                //       parentViewModel.refresh();

                //       BlocProvider.of<FlightSearchCubit>(flightSearchContext).sortFLights(
                //           filterAvailabilityRq: parentViewModel.filterAvailabilityRq,
                //           flightDirection: parentViewModel.flightDirection,
                //           flightSearchResultDTO: parentViewModel.flightSearchResultDTO);
                //     }
                //   });
                // }

                return PreferredSize(preferredSize: tabBar.preferredSize, child: tabBar);
              },
            ),
          ),
        ),
      ),
    );
  }
}
