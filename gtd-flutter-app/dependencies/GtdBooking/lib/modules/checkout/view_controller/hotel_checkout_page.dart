import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/view_model/hotel_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/confirm_booking_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/confirm_booking_page_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/cubit/country_codes_cubit.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_traveller_cubit.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

import '../../confirm_booking/view_controller/pricing_bottom_page.dart';
import '../cubit/checkout_cubit.dart';
import '../views/gotadi/gtd_checkout_content_view.dart';

class HotelCheckoutPage extends PricingBottomPage<HotelCheckoutPageViewModel> {
  static const String route = '/hotelCheckout';
  const HotelCheckoutPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider.value(
      value: BlocProvider.of<RebuildWidgetCubit>(pageContext),
      child: GtdCheckoutContentView(
        viewModel: viewModel.checkoutContentViewModel,
      ),
    );
  }

  @override
  Widget buildBottomNext(BuildContext paymentContext) {
    return StreamBuilder(
        stream: viewModel.checkoutContentViewModel.isEnableCheckoutBtn,
        builder: (context, snapshot) {
          return GtdButton(
            isEnable: snapshot.data ?? false,
            onPressed: (snapshot.data == false)
                ? null
                : (value) {
                    viewModel.confirmListTravelerDTOS(
                      viewModel.checkoutContentViewModel.passengersFormSubject.value,
                      viewModel.checkoutContentViewModel.contactFormSubject.value,
                    );
                    onNext(paymentContext);
                  },
            text: 'global.next'.tr(),
            fontSize: 16,
            height: 48,
            borderRadius: 24,
            gradient: AppColors.appGradient,
          );
        });
  }

  void onNext(BuildContext paymentContext) {
    var confirmViewModel = ConfirmBookingPageViewModel(bookingNumber: viewModel.bookingNumber)
      ..bookingDetailDTO = viewModel.bookingDetailDTO
      ..savedTravellers = viewModel.savedTravellers
      ..countries = viewModel.countries
      ..travelerInputInfos = viewModel.travelerInputInfos
      ..contactInputInfo = viewModel.contactInputInfo
      ..subtitle = viewModel.subTitle
      ..invoiceBookingInfo = viewModel.invoiceBookingInfo;
    paymentContext.push(ConfirmBookingPage.route, extra: confirmViewModel);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (checkoutContext) => CheckoutCubit()..initPassengers(viewModel),
      ),
      BlocProvider(
        create: (savedTravellerContext) => SavedTravellerCubit(),
      ),
      BlocProvider(
        create: (countriesContext) => CountryCodesCubit()..getCountries(),
      ),
    ], child: super.build(context));
  }
}
