import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/flight_searching_loading_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_search_cubit.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_search_state.dart';
import 'package:gtd_booking/modules/flight/search_result/view_controller/flight_search_result_page.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/flight_search_result_page_viewmodel.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_gradient_icon.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

class FlightSearchingLoadingPage extends BaseStatelessPage<FlightSearchingLoadingPageViewModel> {
  static const String route = '/flightSearchingLoadingPage';
  const FlightSearchingLoadingPage({super.key, required super.viewModel});
  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    return null;
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => FlightSearchCubit()..loadLowSearch(viewModel.searchInfoFlightVM)),
          ],
          child: BlocListener<FlightSearchCubit, FlightSearchState>(
            listener: (context, state) {
              if (state is FlightSearchLoadStatusState) {
                switch (state.status) {
                  case FlightSearchStatus.success:
                    // Map<String, dynamic> params = {};
                    // params.putIfAbsent("flightLowSearchRs",
                    //     () => BlocProvider.of<FlightSearchCubit>(context).flightSearchSubject.value);
                    // params.putIfAbsent("flightDirection", () => FlightDirection.d);
                    GtdFlightSearchResultDTO flightSearchResultDTO =
                        BlocProvider.of<FlightSearchCubit>(context).flightSearchSubject.value;
                    FlightSearchResultPageViewModel flightSearchResultPageViewModel = FlightSearchResultPageViewModel(
                        flightSearchResultDTO: flightSearchResultDTO,
                        flightDirection: FlightDirection.d,
                        searchFlightFormModel: viewModel.searchInfoFlightVM);
                    context.pushReplacement(
                      FlightSearchResultPage.route,
                      extra: flightSearchResultPageViewModel,
                    );
                    break;
                  case FlightSearchStatus.cancel:
                    Navigator.pop(context);
                    break;
                  default:
                    // TODO: Handle this case.
                    break;
                }
              } else if (state is FlightSearchErrorState) {
                GtdPopupMessage(context).showError(error: state.apiError.message).then((value) {
                  context.pop();
                });
              }
            },
            child: Scaffold(
              body: SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          child: GtdImage.giftFromSupplier(
                            assetName: 'assets/icons/loading.gif',
                          ),
                        ),
                        const Text(
                          'Đang tìm chuyến bay…',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 16,
                          children: [
                            Text(
                              'Người lớn: '
                              '${viewModel.searchInfoFlightVM.adult}',
                              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Trẻ em: ${viewModel.searchInfoFlightVM.child}',
                              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Trẻ sơ sinh: ${viewModel.searchInfoFlightVM.infant}',
                              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: const Offset(0, -25),
                          child: GtdImage.giftFromSupplier(
                            assetName: "assets/images/loading-search-flight.gif",
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -80),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    children: [
                                      Text(
                                        '${viewModel.searchInfoFlightVM.fromLocation.code}',
                                        style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${viewModel.searchInfoFlightVM.fromLocation.name}',
                                        style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: SizedBox(
                                  width: 20,
                                  child: GtdGradientSvg(
                                    image: GtdImage.svgFromSupplier(assetName: 'assets/icons/flight/flight-single.svg'),
                                    gradient: GtdColors.appGradient(pageContext),
                                  ),
                                )),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      crossAxisAlignment: WrapCrossAlignment.end,
                                      children: [
                                        Text(
                                          '${viewModel.searchInfoFlightVM.toLocation.code}',
                                          style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${viewModel.searchInfoFlightVM.toLocation.name}',
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -60),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            runSpacing: 8,
                            direction: Axis.vertical,
                            children: [
                              Text(
                                'Khởi hành: ${(viewModel.searchInfoFlightVM.departDate?.localDate('EEEE dd/MM/yyyy'))}',
                                style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                              ),
                              viewModel.searchInfoFlightVM.isRoundTrip
                                  ? Text(
                                      'Ngày về: ${(viewModel.searchInfoFlightVM.returnDate?.localDate('EEEE dd/MM/yyyy'))}',
                                      style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  BlocBuilder<FlightSearchCubit, FlightSearchState>(builder: (context2, state) {
                    return GestureDetector(
                        onTap: () {
                          BlocProvider.of<FlightSearchCubit>(context2).cancelSearch();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2.0,
                            ),
                          ),
                          child: const Text(
                            'flight.formSearch.cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ).tr(),
                        ));
                  })
                ],
              )),
            ),
          )),
    );
  }
}
