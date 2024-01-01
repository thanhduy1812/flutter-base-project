import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/cubit/checkout_cubit.dart';
import 'package:gtd_booking/modules/checkout/view_controller/flight_extras_page.dart';
import 'package:gtd_booking/modules/checkout/view_model/combo_extras_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_combo_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_booking/modules/personal_info/cubit/country_codes_cubit.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_traveller_cubit.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

import '../view_model/combo_checkout_page_viewmodel.dart';
import '../views/gotadi/gtd_checkout_content_view.dart';

class ComboCheckoutPage extends PricingBottomPage<ComboCheckoutPageViewModel> {
  static const String route = '/comboCheckout';
  const ComboCheckoutPage({super.key, required super.viewModel});

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
    viewModel.validateTravelerForm().when((success) {
      var inititalSsrs = (viewModel.checkoutContentViewModel as GtdComboCheckoutContentViewModel)
          .ssrItemsSubject
          .value
          .map((e) => e.data)
          .toList();

      var comboExtraViewModel =
          ComboExtrasPageViewModel(bookingDetailDTO: viewModel.bookingDetailDTO, initialSsrItems: inititalSsrs);
      comboExtraViewModel.savedTravellers = viewModel.savedTravellers;
      comboExtraViewModel.countries = viewModel.countries;
      comboExtraViewModel.travelerInputInfos = viewModel.travelerInputInfos;
      comboExtraViewModel.contactInputInfo = viewModel.contactInputInfo;
      comboExtraViewModel.invoiceBookingInfo = viewModel.invoiceBookingInfo;
      paymentContext.push(FlightExtrasPage.route, extra: comboExtraViewModel);
    }, (error) => GtdPopupMessage(paymentContext).showError(error: error.message));
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
