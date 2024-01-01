import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/flight/form_search/bloc_cubit/search_info_cubit.dart';
import 'package:gtd_booking/modules/flight/form_search/bloc_cubit/search_info_state.dart';
import 'package:gtd_booking/modules/flight/form_search/view_controller/flight_searching_loading_page.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/flight_searching_loading_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/search_flight_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/views/date_itinerary_view.dart';
import 'package:gtd_booking/modules/flight/form_search/views/location_info_view.dart';
import 'package:gtd_booking/modules/flight/form_search/views/passengers_inerary_view.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

class SearchFlightPage extends BaseStatelessPage<SearchFlightPageViewModel> {
  static const String route = '/flightSearch';
  final ScrollController scrollController = ScrollController(
    keepScrollOffset: true,
    debugLabel: 'pageBodyScroll',
  );

  SearchFlightPage({super.key, required super.viewModel});
  @override
  List<Widget> buildTrailingActions(BuildContext pageContext) {
    return [
      IconButton(
        splashRadius: 20,
        padding: EdgeInsets.zero,
        onPressed: () => pageContext.push("/myBooking"),
        icon: const Icon(
          Icons.more_horiz_rounded,
        ),
      )
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchInfoCubit()..initSearchInfoFromCache()),
      ],
      child: BlocBuilder<SearchInfoCubit, SearchInfoState>(
        builder: (searchInfoContext, searchInfoState) {
          if (searchInfoState is SearchInfoCachedLoadedState) {
            viewModel.updateFromCache(searchInfoState.searchInfoFlightVM);
          }
          return SafeArea(
              child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Wrap(
                        runSpacing: 20,
                        children: [
                          LocationInfoView(viewModel: viewModel.locationInfoViewModel),
                          DateItineraryView(viewModel: viewModel.dateItineraryViewModel),
                          PassengersItineraryView(
                            viewModel: viewModel.passengerViewModel,
                          ),
                        ],
                      ),
                    )),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text.rich(
                  TextSpan(
                      text: "Vé máy bay cung cấp bởi ",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      children: <InlineSpan>[
                        const TextSpan(text: "Gotadi \n", style: TextStyle(color: Colors.black, fontSize: 12)),
                        TextSpan(
                            text: "Thông tin vé máy bay vui lòng liên hệ 1900-9002",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
              StreamBuilder(
                  stream: viewModel.isEnableSearch,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                        child: GtdButton(
                          isEnable: snapshot.data ?? false,
                          onPressed: (snapshot.data == false)
                              ? null
                              : (value) {
                                  FlightSearchingLoadingPageViewModel searchingViewModel =
                                      FlightSearchingLoadingPageViewModel(
                                          searchInfoFlightVM: viewModel.searchInfoFlightVM);
                                  context.push(FlightSearchingLoadingPage.route, extra: searchingViewModel);
                                },
                          text: 'flight.formSearch.btnSearch'.tr(),
                          height: 48,
                          borderRadius: 24,
                          gradient: GtdColors.appGradient(context),
                        ),
                      ),
                    );
                  })
            ],
          ));
        },
      ),
    );
  }
}
