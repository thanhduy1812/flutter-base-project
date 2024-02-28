import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/booking_result_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/reservation_detail_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_detail_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/reservation_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/booking_detail_loading.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/status_booking.dart';
import 'package:gtd_booking/modules/confirm_booking/views/price_bottom_detail_view.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/go_router_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

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

  Widget titleWidget(BookingDetailDTO? bookingDetail) {
    return Column(
      children: [
        Text(
          'global.confirm'.tr(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (bookingDetail != null)
          Text(
            bookingDetail.departPassengers(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    GtdNativeChannel.shared.handleNativeNavigation(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookingResultCubit()
            ..currentState(
              widget.bookingNumber,
            ),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // title: titleWidget(bookingDetail),
          title: BlocBuilder<BookingResultCubit, BookingResultState>(
            builder: (contextBookingResult, stateBookingResult) {
              final bookingDetail =
                  BlocProvider.of<BookingResultCubit>(contextBookingResult).bookingDetailSubject.valueOrNull;
              return titleWidget(bookingDetail);
            },
          ),
        ),
        body: SafeArea(
          child: ColoredBox(
            color: GtdColors.winterWhite,
            child: Column(
              children: [
                const SizedBox(height: 1),
                _bookingNumber(context),
                Expanded(
                  child: BlocBuilder<BookingResultCubit, BookingResultState>(
                    builder: (contextBookingResult, stateBookingResult) {
                      if (stateBookingResult is BookingDetailErrorState) {
                        return GtdPopupMessage.centerAlert(
                            context: contextBookingResult, error: stateBookingResult.apiError.message);
                      } else {
                        BookingDetailLoadingState? bookingDetailLoadingState =
                            stateBookingResult as BookingDetailLoadingState?;
                        return (bookingDetailLoadingState != null)
                            ? _body(bookingDetailLoadingState, contextBookingResult)
                            : const SizedBox();
                      }
                    },
                  ),
                ),
                _bottomBtn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //MARK: Handle case for VIB Payment
  // _onNext(BuildContext contextBookingResult) {
  //   final bookingDetail = BlocProvider.of<BookingResultCubit>(contextBookingResult).bookingDetailSubject.value;
  //   if (bookingDetail.bookingNumber != null) {
  //     Map<String, dynamic> params = {};
  //     params.putIfAbsent("bookingNumber", () => bookingDetail.bookingNumber);

  //     //MARK get bank number from vib callback
  //     params.putIfAbsent("fromBankNumber", () => '•••• 8734');

  //     GtdNativeChannel.shared.gotoPaymentPartner(bookingDetail.bookingNumber!);
  //     context.push('/vibInvoice', extra: params);
  //   }
  // }

  Widget _bottomBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GtdButton(
              text: 'Về trang chủ',
              height: 50,
              borderRadius: 24,
              colorText: GtdColors.inkBlack,
              fontSize: 15,
              onPressed: (value) {
                GoRouter.of(context).popUntilPath(context, "/home");
                UserManager.shared.popToHomeCallback();
              },
              border: Border.all(
                color: GtdColors.cloudyGrey,
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GtdButton(
              text: 'Quản lý đặt chỗ',
              height: 50,
              borderRadius: 24,
              colorText: Colors.white,
              fontSize: 15,
              onPressed: (value) {
                // _onNext(contextBookingResult);
                GtdNativeChannel.shared.popToPartnerHome();
                context.pushReplacement("/myBooking");
              },
              color: GtdColors.appMainColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _body(
    BookingDetailLoadingState bookingDetailLoadingState,
    BuildContext contextBookingResult,
  ) {
    return Expanded(
      child: Container(
        color: Colors.grey.shade50,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Builder(
            builder: (context) {
              if (bookingDetailLoadingState.status == BookingDetailStatus.success) {
                final bookingDetail =
                    BlocProvider.of<BookingResultCubit>(contextBookingResult).bookingDetailSubject.value;
                return Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookingResultStatus(bookingDetailDTO: bookingDetail),
                      _paymentInfo(bookingDetail),
                      _flightTypeAndFare(bookingDetail),
                      const SizedBox(height: 8),
                      _journeyInfoTitle(),
                      _journeyInfo(bookingDetail),
                      _guideAndNote(),
                      _contactInfo(bookingDetail),
                    ],
                  ),
                );
              } else {
                // define loading booking detail
                return const BookingDetailLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  Column _contactInfo(BookingDetailDTO bookingDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Thông tin liên hệ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: GtdColors.inkBlack,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _DataRow(
                  title: 'Họ & Tên',
                  content: bookingDetail.contactBookingInfo?.fullName ?? '',
                ),
              ),
              const Divider(
                thickness: 1,
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _DataRow(
                  title: 'Điện thoại',
                  content: bookingDetail.contactBookingInfo?.phoneNumber ?? '',
                ),
              ),
              const Divider(
                thickness: 1,
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _DataRow(
                  title: 'Email',
                  content: bookingDetail.contactBookingInfo?.email ?? '',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _guideAndNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Giúp chuyến đi của bạn trở nên dễ dàng hơn!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: GtdColors.inkBlack,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: GtdAppIcon.iconNamedSupplier(
                    iconName: "icon-info-blue.svg",
                    color: GtdColors.pumpkinOrange,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Hướng dẫn & lưu ý',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: GtdColors.inkBlack,
                ),
              ),
              const Spacer(),
              Text(
                'Xem chi tiết',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: GtdColors.emerald,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                color: GtdColors.emerald,
                size: 22,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _journeyInfo(BookingDetailDTO bookingDetail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _DataRow(
            title: 'Chiều đi',
            content: bookingDetail.departFlightTitle(),
          ),
          const SizedBox(height: 20),
          _DataRow(
            title: 'Khách',
            content: bookingDetail.departPassengers(),
          ),
          const SizedBox(height: 12),
          _PNRData(
            code: bookingDetail.departFlightCode(),
            onTap: () {
              context.push(
                ReservationDetailPage.route,
                extra: ReservationDetailPageViewMode.fromFlightItemDetail(
                  flightItemDetail: bookingDetail.flightDetailItems!.first,
                ),
              );
            },
          ),
          if (bookingDetail.isRoundTrip) ...[
            const SizedBox(height: 12),
            _DataRow(
              title: 'Chiều về',
              content: bookingDetail.returnFlightTitle(),
            ),
            const SizedBox(height: 20),
            _DataRow(
              title: 'Khách',
              content: bookingDetail.returnPassengers(),
            ),
            const SizedBox(height: 12),
            _PNRData(
              code: bookingDetail.returnFlightCode(),
              onTap: () {
                context.push(
                  ReservationDetailPage.route,
                  extra: ReservationDetailPageViewMode.fromFlightItemDetail(
                    flightItemDetail: bookingDetail.flightDetailItems!.last,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Padding _journeyInfoTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Tóm tắt hành trình',
        style: TextStyle(
          color: GtdColors.inkBlack,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Container _flightTypeAndFare(BookingDetailDTO bookingDetail) {
    String totalAmount = ((bookingDetail.paymentInfo?.paymentTotalAmount != 0)
            ? bookingDetail.paymentInfo!.paymentTotalAmount!
            : bookingDetail.paymentInfo!.totalFare)
        .toCurrency();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _DataRow(
            title: 'Dịch vụ',
            content: bookingDetail.ticketType(),
          ),
          const SizedBox(height: 8),
          _DataRow(
            title: 'Tổng thanh toán',
            content: totalAmount,
            contentColor: GtdColors.emerald,
            onTap: () {
              GtdPresentViewHelper.presentSheet(
                title: "Chi tiết giá",
                context: context,
                isFullScreen: false,
                builder: Builder(
                  builder: (context) {
                    return SizedBox(
                      width: double.infinity,
                      child: PriceBottomDetailView(
                        viewModel: PriceBottomDetailViewModel.fromBookingDetailDTO(
                          bookingDetail,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container _paymentInfo(BookingDetailDTO bookingDetail) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _DataRow(
            title: 'Ngày thanh toán',
            content: bookingDetail.paymentDate(),
          ),
          const SizedBox(height: 8),
          _DataRow(
            title: 'Phương thức',
            content: bookingDetail.paymentMethod(),
          ),
          const SizedBox(height: 16),
          const _DashLine(),
        ],
      ),
    );
  }

  ColoredBox _bookingNumber(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Mã tham chiếu',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: GtdColors.steelGrey,
                ),
              ),
            ),
            Text(
              widget.bookingNumber,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: GtdColors.inkBlack,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(
                  text: widget.bookingNumber,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Booking number copied",
                    ),
                  ),
                );
              },
              child: GtdAppIcon.iconNamedSupplier(
                iconName: "icon-duplicate.svg",
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
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

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = GtdColors.blueGrey
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _DataRow extends StatelessWidget {
  final String title;
  final String content;
  final Color? contentColor;
  final VoidCallback? onTap;

  const _DataRow({
    required this.title,
    required this.content,
    this.contentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: GtdColors.steelGrey,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            content,
            style: TextStyle(
              color: contentColor ?? GtdColors.inkBlack,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: GtdColors.appMainColor(context),
              size: 24,
            ),
          ],
        ],
      ),
    );
  }
}

class _PNRData extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const _PNRData({required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GtdDashedBorder(
      radius: const Radius.circular(16),
      borderType: BorderType.rRect,
      padding: EdgeInsets.zero,
      dashPattern: const [4, 2],
      color: GtdColors.blueGrey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: GtdColors.winterWhite,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đặt chỗ (PNR)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: GtdColors.steelGrey,
                      ),
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: GtdColors.pumpkinOrange,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(2, 2), // changes position of shadow
                    ),
                  ]),
                  child: Center(
                    child: Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        color: GtdColors.inkBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
