import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

class FlightItemDetail extends StatefulWidget {
  const FlightItemDetail({super.key, required this.flightItemDetail, required this.bookingType});
  final GtdFlightItemDetail flightItemDetail;
  final String bookingType;

  @override
  State<FlightItemDetail> createState() => _FlightItemDetailState();
}

class _FlightItemDetailState extends State<FlightItemDetail> {
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
    GtdFlightItemDetail flightItemDetail = widget.flightItemDetail;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Wrap(
            runSpacing: 24,
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('bookingResult.flight.pnr').tr(),
                    const SizedBox(height: 8),
                    Text(flightItemDetail.transactionInfo?.passengerNameRecord ?? '---',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 96,
                      maxHeight: 40,
                    ),
                    child: GtdImage.imgFromUrl(flightItemDetail.flightItem.flightItemInfo?.airlineLogo ?? ""),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          '${flightItemDetail.flightItem.flightItemInfo?.airline}${flightItemDetail.flightItem.flightItemInfo?.flightNo}'
                          ' | ${flightItemDetail.flightItem.flightItemInfo?.aircraft}',
                          style: const TextStyle(fontSize: 12))
                    ],
                  )),
                ],
              ),
              Row(
                children: [
                  GtdImage.svgFromSupplier(assetName: 'assets/icons/line-booking-detail.svg'),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Wrap(
                    runSpacing: 16,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flightItemDetail.flightItem.flightItemInfo!.originDateTime != null
                                  ? dateFormatFlight.format(flightItemDetail.flightItem.flightItemInfo!.originDateTime!)
                                  : '',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${flightItemDetail.flightItem.flightItemInfo?.originLocation?.city} (${flightItemDetail.flightItem.flightItemInfo?.originLocation?.locationCode})',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          GtdDateTime.timeStampToDateString(
                              flightItemDetail.flightItem.flightItemInfo?.journeyDuration),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flightItemDetail.flightItem.flightItemInfo!.destinationDateTime != null
                                  ? dateFormatFlight
                                      .format(flightItemDetail.flightItem.flightItemInfo!.destinationDateTime!)
                                  : '',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${flightItemDetail.flightItem.flightItemInfo?.destinationLocation?.city} (${flightItemDetail.flightItem.flightItemInfo?.destinationLocation?.locationCode})',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade200,
          thickness: 0.5,
          height: 0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 52,
          child: Row(
            children: [
              Text('Hạng vé', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
              Expanded(
                  child: flightItemDetail.flightItem.cabinOptions?.first.cabinClassName != null
                      ? const Text(
                          'flight.item.cabinClassName',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.right,
                        ).tr(gender: flightItemDetail.flightItem.cabinOptions?.first.cabinClassName)
                      : const Text('')),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade200,
          thickness: 0.5,
          height: 0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 52,
          child: Row(
            children: [
              Text('Điểm dừng', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
              const Expanded(
                  child: Text(
                'Bay thẳng',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                textAlign: TextAlign.right,
              )),
            ],
          ),
        )
      ],
    );
  }
}
