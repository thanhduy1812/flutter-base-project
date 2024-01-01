import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

class StatusBooking extends StatefulWidget {
  const StatusBooking({super.key, required this.bookingDetailDTO});

  final BookingDetailDTO bookingDetailDTO;

  @override
  State<StatusBooking> createState() => _StatusBookingState();
}

class _StatusBookingState extends State<StatusBooking> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
      decoration: BoxDecoration(
        color: GenerateStatus.generareStatusMapping(context, (widget.bookingDetailDTO.status)!).statusBackground,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'myBooking.bookingStatus.${widget.bookingDetailDTO.supplierType}'
                .tr(gender: widget.bookingDetailDTO.status),
            style: TextStyle(
                color: GenerateStatus.generareStatusMapping(context, (widget.bookingDetailDTO.status)!).statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          GtdImage.svgFromSupplier(
              assetName: GenerateStatus.generareStatusMapping(context, (widget.bookingDetailDTO.status)!).pathIcon!)
          // SvgPicture.asset(
          //   GtdString.pathForAsset(
          //     BookingConst.shared.assetPackage,
          //     (GenerateStatus.generareStatusMapping(
          //       context,
          //       (widget.bookingDetailDTO.status)!
          //     ).pathIcon)!
          //   )
          // )
        ],
      ),
    );
  }
}
