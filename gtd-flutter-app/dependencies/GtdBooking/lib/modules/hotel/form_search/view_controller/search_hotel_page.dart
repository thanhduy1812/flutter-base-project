import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/date_checkinout_view.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/hotel_search_location_view.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/passengers_room_view.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_controller/hotel_searching_loading_page.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/hotel_searching_loading_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/search_hotel_page_viewmodel.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';

import '../cubit/hotel_search_form_cubit.dart';

class SearchHotelPage extends BaseStatelessPage<SearchHotelPageViewModel> {
  static const String route = '/hotelSearch';
  const SearchHotelPage({super.key, required super.viewModel});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelSearchFormCubit(viewModel: viewModel),
      child: BlocBuilder<HotelSearchFormCubit, HotelSearchFormState>(
        builder: (context, state) {
          var stateViewModel = BlocProvider.of<HotelSearchFormCubit>(context).viewModel;
          viewModel.checkinoutViewModel = stateViewModel.checkinoutViewModel;
          viewModel.hotelLocation = stateViewModel.hotelLocation;
          viewModel.passengersRoomViewModel = stateViewModel.passengersRoomViewModel;
          viewModel.validLocationHotel();
          return super.build(context);
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            color: Colors.white,
            child: GtdTextField(
              viewModel: viewModel.hotelLocation,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leftIcon: GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-grey.svg", width: 34),
              rightIcon: SizedBox(child: GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-my-location.svg")),
              onSelect: () => showHotelSearchLocation(pageContext),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DateCheckinoutView(viewModel: viewModel.checkinoutViewModel),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: PassengersRoomView(viewModel: viewModel.passengersRoomViewModel),
        ),
        const Spacer(),
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
              stream: viewModel.isEnableButtonStream,
              builder: (context, snapshot) {
                return GtdButton(
                  text: "Tìm khách sạn",
                  color: AppColors.mainColor,
                  isEnable: snapshot.data ?? false,
                  height: 50,
                  borderRadius: 25,
                  onPressed: (value) {
                    var hotelLoadingViewModel =
                        HotelSearchingLoadingPageViewModel(searchHotelFormModel: viewModel.searchHotelFormModel);
                    viewModel.savedCachedHotelLocations(viewModel.hotelLocation.location);
                    viewModel.savedCachedHotelFormModel(viewModel.searchHotelFormModel);
                    pageContext.push(HotelSearchingLoadingPage.route, extra: hotelLoadingViewModel);
                  },
                );
              }),
        ),
      ],
    );
  }

  void showHotelSearchLocation(BuildContext pageContext) {
    HotelSearchLocationViewHelper.showHotelSearchLocation(
      pageContext: pageContext,
      onSelected: (value) {
        viewModel.selectedHotelLocationDTO = value;
        BlocProvider.of<RebuildWidgetCubit>(pageContext).rebuildWidget();
      },
    );
  }
}
