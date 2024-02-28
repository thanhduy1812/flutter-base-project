import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/view_controller/hotel_ssr_selection_page.dart';
import 'package:gtd_booking/modules/checkout/view_model/hotel_ssr_selection_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/insurance_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_utils/base/view/gtd_input_select/gtd_input_select_cell.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';

import '../cubit/flight_service_request_cubit.dart';
import '../model/hotel_additional_item_vm.dart';
import '../view_model/flight_extras_page_viewmodel.dart';
import '../view_model/flight_ssr_selection_page_viewmodel.dart';
import '../views/gotadi/gtd_ssr_items/view_model/gtd_ssr_items_list_viewmodel.dart';
import 'flight_ssr_selection_page.dart';

class FlightExtrasPage extends PricingBottomPage<FlightExtrasPageViewModel> {
  static const String route = "/flightExtrasPage";
  const FlightExtrasPage({super.key, required super.viewModel});

  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    viewModel.title = "Tiện ích mua thêm";
    return super.buildAppbar(pageContext);
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FlightServiceRequestCubit(bookingDetailDTO: viewModel.bookingDetailDTO!)
            ..initWithServiceRequest(viewModel.initialSsrItems),
        ),
        BlocProvider(
          create: (context) => InsuranceCubit()
            ..getInsuracePlans(
                insurancePlanRq: viewModel.createInsuranceRequest(
                    planId: viewModel.bookingDetailDTO?.isInternational == true ? 2 : 1)),
        ),
      ],
      child: BlocBuilder<FlightServiceRequestCubit, FlightServiceRequestState>(
        builder: (flightServiceContext, flightServiceState) {
          if (flightServiceState is FlightServiceRequestLoaded) {
            viewModel.initialSsrItems = flightServiceState.ssrOfferDTOs;
          }
          return BlocBuilder<InsuranceCubit, InsuranceState>(
            builder: (insuranceContext, insuranceState) {
              if (insuranceState is InsurancePlanLoaded) {
                viewModel.initialInsurancePlans = insuranceState.insurancePlans;
              }
              return SizedBox(
                child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(16),
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var serviceType = viewModel.serviceTypes[index];
                          bool isEnableSelectCell = false;
                          if (serviceType != ServiceType.insurance) {
                            isEnableSelectCell = flightServiceState is FlightServiceRequestLoaded;
                          } else {
                            isEnableSelectCell =
                                insuranceState is InsurancePlanLoaded && viewModel.checkAllowedBuyFlexiInsurance(false);
                          }
                          return GtdInputSelectCell(
                            isEnable: isEnableSelectCell,
                            leadingIcon: SizedBox(
                                height: 40,
                                width: 40,
                                child: FittedBox(
                                  child: viewModel.iconByServiceType(serviceType).item1,
                                )),
                            title: viewModel.iconByServiceType(serviceType).item2.item1,
                            subTitle: viewModel.extrasDescription(serviceType),
                            hasData: viewModel.extrasDescription(serviceType).isNotEmpty,
                            defaultSubTitle: viewModel.iconByServiceType(serviceType).item2.item2,
                            onSelect: (isEnableSelectCell)
                                ? () {
                                    if (serviceType == ServiceType.hotelAdditional) {
                                      HotelSSRSelectionPageViewModel hotelSSRSelectionPageViewModel =
                                          HotelSSRSelectionPageViewModel(
                                              selectedHotelAdditionalItems: viewModel.selectedHotelItems);
                                      var result = context.push<List<HotelAdditionalItemVM>?>(
                                          HotelSSRSelectionPage.route,
                                          extra: hotelSSRSelectionPageViewModel);
                                      result.then((value) {
                                        viewModel.selectedHotelItems = value ?? [];
                                      });
                                    } else {
                                      bool isRoundTrip =
                                          viewModel.bookingDetailDTO?.roundType?.toLowerCase() == "roundtrip";
                                      FlightSSRSelectionPageViewModel ssrSelectionPageViewModel =
                                          FlightSSRSelectionPageViewModel(
                                        isRoundTrip: isRoundTrip,
                                        bookingDetailDTO: viewModel.bookingDetailDTO,
                                        serviceType: serviceType,
                                        initialSsrItems: viewModel.initialSsrItems,
                                        initialInsurancePlans: viewModel.initialInsurancePlans,
                                        inputInfoDTOs: viewModel.travelerInputInfos,
                                      );
                                      var result = context.push<List<SelectedSSRTuple>>(FlightSSRSelectionPage.route,
                                          extra: ssrSelectionPageViewModel);
                                      result.then((value) {
                                        if (value != null) {
                                          viewModel.updateSelectedSSRItemToTravelers(value, serviceType);
                                        }
                                      });
                                    }
                                  }
                                : null,
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: viewModel.serviceTypes.length)),
              );
            },
          );
        },
      ),
    );
  }
}
