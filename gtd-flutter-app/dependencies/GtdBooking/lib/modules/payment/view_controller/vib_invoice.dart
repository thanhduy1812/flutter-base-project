import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/booking_result_cubit.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_list_title.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';

class VibInvoicePage extends StatefulWidget {
  final String bookingNumber;
  // final String fromBankNumber;

  const VibInvoicePage({super.key, required this.bookingNumber});

  static const String route = '/vibInvoice';

  @override
  State<VibInvoicePage> createState() => _VibInvoiceState();
}

class _VibInvoiceState extends State<VibInvoicePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BookingResultCubit()..currentState(widget.bookingNumber)),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Hóa đơn'),
            automaticallyImplyLeading: false,
          ),
          body:
              BlocBuilder<BookingResultCubit, BookingResultState>(builder: (contextBookingResult, stateBookingResult) {
            return SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(22),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                child: GtdImage.svgFromSupplier(
                                  assetName: 'assets/icons/check.svg',
                                ),
                              ),
                            ),
                            const GtdText(
                              text: 'Đặt vé thành công',
                              textType: TextType.headlineLarge,
                            ),
                            const GtdText(
                              text:
                                  'Quý khách vui lòng thanh toán trước 16:52, Thứ 4 25/10/2022 để hoàn thành việc đặt chỗ',
                              textType: TextType.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const Card(
                              child: Column(children: [
                                GtdListTitle(
                                  title: 'Ngày thực hiện',
                                  trailing: '22/09/2022',
                                ),
                                GtdListTitle(
                                  title: 'Tổng tiền',
                                  trailing: '3,485,600 đ',
                                ),
                                GtdListTitle(
                                  title: 'Từ tài khoản',
                                  trailing: '•••• 8734',
                                  borderLine: false,
                                ),
                              ]),
                            ),
                            const Card(
                              child: Column(children: [
                                GtdListTitle(
                                  title: 'Thời gian đi',
                                  trailing: '25/10/2022',
                                ),
                                GtdListTitle(
                                  title: 'Nơi đi',
                                  trailing: 'Ho Chi Minh (SGN)',
                                ),
                                GtdListTitle(
                                  title: 'Nơi đến',
                                  trailing: 'Ha Noi (HAN)',
                                  borderLine: false,
                                ),
                              ]),
                            ),
                            const Card(
                              child: Column(children: [
                                GtdListTitle(
                                  title: 'Thời gian về',
                                  trailing: '25/10/2022',
                                ),
                                GtdListTitle(
                                  title: 'Nơi đi',
                                  trailing: 'Ha Noi (HAN)',
                                ),
                                GtdListTitle(
                                  title: 'Nơi đến',
                                  trailing: 'Ho Chi Minh (SGN)',
                                  borderLine: false,
                                ),
                              ]),
                            ),
                            const Card(
                              child: Column(children: [
                                GtdListTitle(
                                  title: 'Họ và tên',
                                  trailing: 'Nguyễn Kiều Cẩm Thơ',
                                ),
                                GtdListTitle(
                                  title: 'Điện thoại',
                                  trailing: '0908092092',
                                ),
                                GtdListTitle(
                                  title: 'Email',
                                  trailing: 'nguyenkieucamtho@gmail.com',
                                  borderLine: false,
                                ),
                              ]),
                            )
                          ]
                              .map((widgetItem) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: widgetItem,
                                  ))
                              .toList(),
                        ),
                      )),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GtdButton(
                          onPressed: (value) {
                            //Back to home if success
                            GtdNativeChannel.shared.popToPartnerHome();
                            context.go("/myBooking");
                          },
                          text: 'Quản lý vé',
                          height: 48,
                          borderRadius: 10,
                          gradient: GtdColors.appGradient(context),
                        ),
                      )
                    ],
                  ),
                ));
          }),
        ));
  }
}
