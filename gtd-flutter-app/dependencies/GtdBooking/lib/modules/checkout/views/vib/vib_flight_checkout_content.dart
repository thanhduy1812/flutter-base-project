import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';

import '../../cubit/flight_checkout_cubit.dart';
import '../../view_model/checkout_traveller_form_vm.dart';
import '../../view_model/flight_checkout_page_viewmodel.dart';
import '../box_contact_info.dart';
import '../box_flight_information.dart';
import '../box_passenger_form.dart';
import '../box_service_request.dart';

class VibFlightCheckoutContent extends StatelessWidget {
  const VibFlightCheckoutContent({super.key});

  @override
  Widget build(BuildContext context) {
    // late final ScrollController scrollController;
    // scrollController = ScrollController(
    //   keepScrollOffset: true,
    //   debugLabel: 'pageBodyScroll',
    // );
    FlightCheckoutPageViewModel? viewModel = context.viewModelOf<FlightCheckoutPageViewModel>();
    if (viewModel == null) {
      return const SizedBox();
    } else {
      return BlocBuilder<FlightCheckoutCubit, CheckoutState>(
        builder: (infoFormContext, infoFormState) {
          BlocProvider.of<FlightCheckoutCubit>(infoFormContext).getServiceRequests();
          List<CheckoutTravellerFormVM> travellers =
              BlocProvider.of<FlightCheckoutCubit>(infoFormContext).passengersFormSubject.value;
          CheckoutTravellerFormVM contactForm =
              BlocProvider.of<FlightCheckoutCubit>(infoFormContext).contactFormSubject.value;
          return Ink(
            color: Colors.grey.shade50,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: BoxFlightInformation(
                      flighItems: viewModel.bookingDetailDTO?.flightDetailItems ?? [],
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: travellers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Ink(
                        color: Colors.transparent,
                        child: Wrap(
                          runSpacing: 20,
                          children: [
                            BoxPassengerForm(
                              key: travellers[index].position,
                              travellerForm: travellers[index],
                            ),
                            BoxServiceRequest(
                              position: travellers[index].position,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: BoxContactInfo(
                      key: contactForm.position,
                      contactForm: contactForm,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
