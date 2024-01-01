import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/_flight_item_detail.dart';

import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';

import '_passenger_detail.dart';


class FlightGroupBooking extends StatefulWidget {
  const FlightGroupBooking({
    super.key,
    required this.bookingDetailDTO
  });
  final BookingDetailDTO bookingDetailDTO;

  @override
  State<FlightGroupBooking> createState() => _FlightGroupBookingState();
}

class _FlightGroupBookingState extends State<FlightGroupBooking> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookingDetailDTO bookingDetail = widget.bookingDetailDTO;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: bookingDetail.flightDetailItems?.length,
      itemBuilder: (context, index) {
        GtdFlightItemDetail flightItemDetail = bookingDetail.flightDetailItems![index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14, top: 10),
                child: const Text(
                  'bookingResult.flight',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ).tr(gender: flightItemDetail.flightDirection.value),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Wrap(
                  runSpacing: 24,
                  children: [
                    FlightItemDetail(
                      flightItemDetail: flightItemDetail,
                      bookingType: bookingDetail.bookingType!
                    ),
                    PassengerDetail(
                      travelerInfo: flightItemDetail.travelersInfo,
                      flightDirection: flightItemDetail.flightDirection
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
