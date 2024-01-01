import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/combo/form_search/view/combo_passengers_room_view.dart';
import 'package:gtd_booking/modules/combo/form_search/view_controller/combo_searching_loading_page.dart';
import 'package:gtd_booking/modules/combo/form_search/view_model/combo_searching_loading_page_viewmodel.dart';
import 'package:gtd_booking/modules/combo/form_search/view_model/search_combo_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/views/date_itinerary_view.dart';
import 'package:gtd_booking/modules/flight/form_search/views/location_info_view.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/date_checkinout_view.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/hotel_search_location_view.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';

class SearchComboPage extends BaseStatelessPage<SearchComboPageViewModel> {
  static const String route = '/searchComboPage';
  const SearchComboPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: LocationInfoView(viewModel: viewModel.searchFlightViewModel.locationInfoViewModel),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                      child: DateItineraryView(
                        viewModel: viewModel.searchFlightViewModel.dateItineraryViewModel,
                        onChangedRoundTrip: (value) {
                          setState(
                            () {
                              if (value == false) {
                                viewModel.enablePickerHotel = !value;
                                viewModel.updateStateHotelForm();
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ComboPassengersRoomView(viewModel: viewModel.passengersRoomViewModel),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StatefulBuilder(builder: (context, setStateHotelPicker) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setStateHotelPicker(
                                  () {
                                    viewModel.toogleHotelDifference();
                                  },
                                );
                              },
                              child: Card(
                                elevation: 1,
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text.rich(TextSpan(
                                            text: "Khách sạn \n",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                            children: [
                                              TextSpan(
                                                  text: "Bạn muốn tìm khách sạn ở địa điểm khác / ngày khác?",
                                                  style:
                                                      TextStyle(fontWeight: FontWeight.w400, color: AppColors.subText))
                                            ])),
                                      ),
                                      GtdRadio(
                                        selectedIcon:
                                            GtdAppIcon.iconNamedSupplier(iconName: "radio/radio-checkbox-active.svg"),
                                        unselectedIcon:
                                            GtdAppIcon.iconNamedSupplier(iconName: "radio/radio-checkbox.svg"),
                                        value: viewModel.enablePickerHotel,
                                        groupValue: true,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: viewModel.enablePickerHotel
                                  ? Column(
                                      children: [
                                        Card(
                                          elevation: 1,
                                          margin: EdgeInsets.zero,
                                          color: Colors.white,
                                          child: GtdTextField(
                                            viewModel: viewModel.searchHotelViewModel.hotelLocation,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            leftIcon: GtdAppIcon.iconNamedSupplier(
                                                iconName: "hotel/hotel-grey.svg", width: 34),
                                            rightIcon: SizedBox(
                                                child: GtdAppIcon.iconNamedSupplier(
                                                    iconName: "hotel/hotel-my-location.svg")),
                                            onSelect: () => showHotelSearchLocation(pageContext, setState),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        DateCheckinoutView(
                                            viewModel: viewModel.searchHotelViewModel.checkinoutViewModel),
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 40,
                child: Center(
                    child: Text.rich(TextSpan(
                        text: "Thông tin hỗ trợ vui lòng liên hệ ",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey.shade500),
                        children: [
                      TextSpan(
                        text: "1900-9002",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey.shade900),
                      )
                    ]))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
              child: StreamBuilder(
                  stream: viewModel.isEnableSearchCombo,
                  builder: (context, snapshot) {
                    return GtdButton(
                      text: "Tìm vé combo",
                      color: AppColors.mainColor,
                      isEnable: snapshot.data ?? false,
                      height: 50,
                      borderRadius: 25,
                      onPressed: (value) {
                        var comboLoadingViewModel = ComboSearchingLoadingPageViewModel(
                            searchHotelFormModel: viewModel.searchHotelComboFormModel,
                            searchFlightFormModel: viewModel.searchFlightComboFormModel);
                        pageContext.push(ComboSearchingLoadingPage.route, extra: comboLoadingViewModel);
                      },
                    );
                  }),
            ),
          ],
        );
      },
    );
  }

  void showHotelSearchLocation(BuildContext pageContext, StateSetter setState) {
    HotelSearchLocationViewHelper.showHotelSearchLocation(
      pageContext: pageContext,
      onSelected: (value) {
        setState(
          () {
            viewModel.searchHotelViewModel.selectedHotelLocationDTO = value;
          },
        );
      },
    );
  }
}
