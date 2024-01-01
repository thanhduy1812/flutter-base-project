import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/booking_result_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/views/booking_detail_loading.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/group_booking.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/status_booking.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

class BookingResultPage extends StatefulWidget {
  final String bookingNumber;

  const BookingResultPage({super.key, required this.bookingNumber});

  static const String route = '/flightBookingResult';

  @override
  State<BookingResultPage> createState() => _BookingResultState();
}

class _BookingResultState extends State<BookingResultPage> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      keepScrollOffset: true,
      debugLabel: 'pageBodyScroll',
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GtdNativeChannel.shared.handleNativeNavigation(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => BookingResultCubit()..currentState(widget.bookingNumber)),
        ],
        child: BlocBuilder<BookingResultCubit, BookingResultState>(
            builder: (contextBookingResult, stateBookingResult) {
          if (stateBookingResult is BookingDetailErrorState) {
            GtdPopupMessage(contextBookingResult)
                .showError(error: stateBookingResult.apiError.message);
          }
          BookingDetailLoadingState bookingDetailLoadingState =
              stateBookingResult as BookingDetailLoadingState;
          return Scaffold(
              appBar: AppBar(
                title: const Text('bookingResult.flight.title').tr(),
              ),
              body: SafeArea(
                  child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade50,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Builder(builder: (context) {
                          if (bookingDetailLoadingState.status == BookingDetailStatus.success) {
                            final bookingDetail =
                                BlocProvider.of<BookingResultCubit>(contextBookingResult)
                                    .bookingDetailSubject
                                    .value;
                            return Container(
                              margin: const EdgeInsets.all(16),
                              child: Wrap(
                                runSpacing: 20,
                                children: [
                                  StatusBooking(bookingDetailDTO: bookingDetail),
                                  FlightGroupBooking(bookingDetailDTO: bookingDetail)
                                ],
                              ),
                            );
                          } else {
                            // define loading booking detail
                            return const BookingDetailLoading();
                          }
                        }),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {

                            final bookingDetail =
                                BlocProvider.of<BookingResultCubit>(contextBookingResult)
                                    .bookingDetailSubject
                                    .value;
                            if (bookingDetail.bookingNumber != null) {
                              Map<String, dynamic> params = {};
                              params.putIfAbsent(
                                  "bookingNumber", () => bookingDetail.bookingNumber);

                              //TODO get bank number from vib callback
                              params.putIfAbsent("fromBankNumber", () => '•••• 8734');

                              GtdNativeChannel.shared
                                  .gotoPaymentPartner(bookingDetail.bookingNumber!);
                              context.push('/vibInvoice', extra: params);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: GtdColors.appMainColor(context),
                              gradient: GtdColors.appGradient(context),
                            ),
                            child: const Text(
                              'global.next',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ).tr(),
                          ))
                    ],
                  ),
                ],
              )));
        }));
  }
}
