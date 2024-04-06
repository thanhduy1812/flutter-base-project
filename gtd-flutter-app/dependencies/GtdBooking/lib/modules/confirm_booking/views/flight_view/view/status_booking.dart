import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/booking_result.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
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
        color: GenerateStatus.generareStatusMapping(
          context,
          (widget.bookingDetailDTO.status)!,
        ).statusBackground,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'myBooking.bookingStatus.${widget.bookingDetailDTO.supplierType}'
                .tr(gender: widget.bookingDetailDTO.status),
            style: TextStyle(
              color: GenerateStatus.generareStatusMapping(
                context,
                (widget.bookingDetailDTO.status)!,
              ).statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          GtdImage.svgFromSupplier(
            assetName: GenerateStatus.generareStatusMapping(
              context,
              (widget.bookingDetailDTO.status)!,
            ).pathIcon!,
          )
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

class BookingResultStatus extends StatefulWidget {
  final BookingDetailDTO bookingDetailDTO;

  const BookingResultStatus({
    required this.bookingDetailDTO,
    super.key,
  });

  @override
  State<BookingResultStatus> createState() => _BookingResultStatusState();
}

class _BookingResultStatusState extends State<BookingResultStatus> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _statusColor(),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              children: [
                GtdImage.svgFromSupplier(assetName: _statusIcon()),
                const SizedBox(height: 8),
                Text(
                  _statusText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: GtdColors.inkBlack,
                  ),
                ),
                const SizedBox(height: 16),
                const _DashLine(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusIcon() {
    switch (widget.bookingDetailDTO.status) {
      case 'EXPIRED':
      case 'PAYMENT_FAILED':
      case 'FAILED':
        return 'assets/icons/status/booking-status-failed.svg';
      case 'SUCCEEDED':
        return 'assets/icons/status/booking-status-success.svg';
      case 'BOOKED':
      case 'TICKED_ON_PROCESS':
        return 'assets/icons/status/booking-status-pending.svg';
      default:
        return 'assets/icons/status/booking-status-pending.svg';
    }
  }

  Color _statusColor() {
    switch (widget.bookingDetailDTO.status) {
      case 'EXPIRED':
      case 'PAYMENT_FAILED':
      case 'FAILED':
        return GtdColors.crimsonRed;
      case 'SUCCEEDED':
        return GtdColors.emerald;
      case 'BOOKED':
      case 'TICKED_ON_PROCESS':
      case 'PENDING':
        return GtdColors.amber;
      default:
        return Colors.white;
    }
  }

  String _statusText() {
    switch (widget.bookingDetailDTO.status) {
      case 'EXPIRED':
        return 'Hết hiệu lực';
      case 'PAYMENT_FAILED':
        return 'Thanh toán thất bại';
      case 'FAILED':
        return 'Thanh toán thất bại,\nxuất vé thất bại';
      case 'SUCCEEDED':
        return 'Thanh toán thành công,\nxuất vé thành công';
      case 'BOOKED':
        return 'Giao dịch chờ thanh toán';
      case 'TICKED_ON_PROCESS':
        return 'Đang chờ xử lý';
      case 'PENDING':
        return 'Chưa thực hiện đặt vé';
      default:
        return widget.bookingDetailDTO.status ?? '';
    }
  }
}

class _DashLine extends StatelessWidget {
  const _DashLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: DashedLinePainter(),
      ),
    );
  }
}
