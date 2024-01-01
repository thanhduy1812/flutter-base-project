import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/cubit/flight_fare_rules_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_item_detail_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_tabbar/view/gtd_tabbar_helper.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_html_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'flight_itinerary_detail/view_model/flight_itinerary_info_viewmodel.dart';
import 'flight_itinerary_detail/views/flight_itinerary_info_view.dart';



class FlightItemDetailView extends BaseView<FlightItemDetailViewModel> {
  const FlightItemDetailView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FlightFareRulesCubit()..flightFareRules(viewModel.flightItemDetail.transactionInfo!.bookingNumber!),
      child: BlocBuilder<FlightFareRulesCubit, FlightFareRulesState>(
        builder: (fareRuleContext, fareRuleState) {
          if (fareRuleState is FlightFareRulesInitial) {
            viewModel.bookedFareRules = fareRuleState.bookedFareRules;
          }

          return DefaultTabController(
            length: 2,
            child: SizedBox(
              child: Column(
                children: [
                  ColoredBox(
                    color: Colors.white,
                    child: GtdTabbarHelper.buildGotadiTabbar(tabs: [
                      const Tab(
                        text: "Chi tiết hành trình",
                      ),
                      const Tab(
                        text: "Chính sách vé",
                      )
                    ]),
                  ),
                  ColoredBox(
                    color: CustomColors.mainOrange,
                    child: SizedBox(
                      height: 52,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              viewModel.titleHeader,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              viewModel.dateTime,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              sliver: SliverToBoxAdapter(
                                child: ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => FlightItineraryInfoView(
                                        viewModel: FlightItineraryInfoViewModel.fromFlightItem(
                                            indexItem: index, flightItemDetail: viewModel.flightItemDetail)),
                                    separatorBuilder: (context, index) => const SizedBox(
                                          height: 4,
                                        ),
                                    itemCount: viewModel.flightItemDetail.flightItem.transitInfos.length),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          child: viewModel.flightFareRuleContent == null
                              ? const Center(child: Text("Fare rule is coming"))
                              : SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  child: GtdHtmlView(
                                    htmlString: viewModel.flightFareRuleContent,
                                    onLinkTap: ({attributes, url}) async {
                                      final Uri policyUrl = Uri.parse(url!);
                                      if (!await launchUrl(policyUrl)) {
                                        print("cannot open url");
                                      }
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
