import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/cubit/flight_fare_rules_cubit.dart';

import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view_model/hotel_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/reservation_detail_view/view_model/booking_traveler_info_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/reservation_detail_view/views/booking_traveler_info_view.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_product_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_html_view.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view_model/reservation_detail_page_viewmodel.dart';
import '../views/flight_view/view/flight_itinerary_detail/view_model/flight_itinerary_info_viewmodel.dart';
import '../views/flight_view/view/flight_itinerary_detail/views/flight_itinerary_info_view.dart';
import '../views/hotel_view/view/hotel_summary_detail_item.dart';

class ReservationDetailPage extends BaseStatelessPage<ReservationDetailPageViewMode> {
  static const String route = '/reservationDetailPage';
  const ReservationDetailPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return SizedBox(
      child: Column(
        children: [
          viewModel.productType == GtdProductType.air
              ? ColoredBox(
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
                )
              : const SizedBox(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text.rich(
                          TextSpan(
                            text: "Mã đặt chỗ (PNR)\n",
                            children: [
                              TextSpan(
                                  text: viewModel.productTransationInfo?.passengerNameRecord ?? "---",
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w700, color: CustomColors.mainOrange)),
                            ],
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.normalText),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            (switch (viewModel.productType) {
                              GtdProductType.air => "Thông tin hành trình",
                              GtdProductType.hotel => "Thông tin khách & phòng",
                              GtdProductType.combo => "Thông tin Combo"
                            }),
                            style: TextStyle(fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (viewModel.productType == GtdProductType.air) {
                              return BlocProvider(
                                create: (context) => FlightFareRulesCubit()
                                  ..flightFareRules(viewModel.productTransationInfo!.bookingNumber!),
                                child: BlocBuilder<FlightFareRulesCubit, FlightFareRulesState>(
                                  builder: (fareRuleContext, fareRuleState) {
                                    if (fareRuleState is FlightFareRulesInitial) {
                                      viewModel.bookedFareRules = fareRuleState.bookedFareRules;
                                    }
                                    return ListView.separated(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => FlightItineraryInfoView(
                                            viewModel: FlightItineraryInfoViewModel.fromFlightItem(
                                                indexItem: index, flightItemDetail: viewModel.flightItemDetail!)),
                                        separatorBuilder: (context, index) => const SizedBox(
                                              height: 4,
                                            ),
                                        itemCount: viewModel.flightItemDetail!.flightItem.transitInfos.length);
                                  },
                                ),
                              );
                            }
                            if (viewModel.productType == GtdProductType.hotel) {
                              return HotelSummaryDetailItem(
                                  viewModel: HotelSummaryItemViewModel.fromHotelProduct(
                                      hotelProductDetail: viewModel.hotelProductDetail!));
                            }
                            return const SizedBox();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: InkWell(
                      onTap: () {
                        if (viewModel.productType == GtdProductType.air) {
                          GtdPresentViewHelper.presentView(
                              title: "Fare rule",
                              context: pageContext,
                              builder: Builder(
                                builder: (context) {
                                  return SizedBox(
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
                                  );
                                },
                              ));
                        }
                      },
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: GtdInfoRow.seperatedRow(
                              title: Text(
                            (switch (viewModel.productType) {
                              GtdProductType.air => "Lưu ý xem Điều kiện & Chính sách vé trước chuyến bay",
                              GtdProductType.hotel => "Lưu ý xem Điều kiện & Chính sách chỗ nghỉ của bạn",
                              GtdProductType.combo => "Lưu ý xem Điều kiện & Chính sách vé trước chuyến bay"
                            }),
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Thông tin hành khách",
                            style: TextStyle(fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var passengerInfo = viewModel.listPassengerInfo[index];
                                return InkWell(
                                  onTap: () {
                                    GtdPresentViewHelper.presentView(
                                        title: "Thông tin khách",
                                        contentPadding: const EdgeInsets.all(0),
                                        context: context,
                                        builder: Builder(
                                          builder: (context) {
                                            return ColoredBox(
                                              color: Colors.grey.shade100,
                                              child: BookingTravelerInfoView(
                                                  viewModel: BookingTravelerInfoViewModel.fromTravelerInfoElement(
                                                      title: passengerInfo.title,
                                                      traveler: passengerInfo.traveler,
                                                      flightDirection: viewModel.flightItemDetail?.flightDirection ??
                                                          FlightDirection.trip)),
                                            );
                                          },
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: GtdInfoRow.seperatedRow(
                                        title: Text.rich(TextSpan(
                                            text: "${passengerInfo.title} \n",
                                            style: TextStyle(
                                                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                                            children: [
                                          TextSpan(
                                              text:
                                                  "${passengerInfo.traveler.surName} ${passengerInfo.traveler.firstName}, ${passengerInfo.traveler.dob?.utcDate("dd/MM/yyyy") ?? passengerInfo.traveler.gender ?? ""}",
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText))
                                        ]))),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: viewModel.listPassengerInfo.length),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
