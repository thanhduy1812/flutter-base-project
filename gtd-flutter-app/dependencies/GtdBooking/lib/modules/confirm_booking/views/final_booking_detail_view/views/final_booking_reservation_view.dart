import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/reservation_detail_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/reservation_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/view_model/final_booking_reservation_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';

class FinalBookingReservationView extends BaseView<FinalBookingReservationViewModel> {
  const FinalBookingReservationView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return SizedBox(
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFFF47920),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thông tin đặt chỗ",
                      style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColoredBox(
                    color: Colors.white,
                    child: SizedBox(
                      child: ListView.custom(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childrenDelegate: SliverChildListDelegate.fixed(
                            [..._buildFlighReservationInfo(context), ..._buildHotelReservationInfo(context)]),
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

  List<Widget> _buildFlighReservationInfo(BuildContext context) {
    return viewModel.flightItemDetails.map((e) {
      return SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 46,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdInfoRow(leftText: e.flightDirectionTitle, rightText: e.inineraryCityTitle)),
            ),
            SizedBox(
              height: 46,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GtdInfoRow(leftText: "Khách", rightText: e.inineraryPassengerTitle),
              ),
            ),
            GtdDashedBorder(
              borderType: BorderType.rRect,
              color: CustomColors.borderColor,
              padding: EdgeInsets.zero,
              radius: const Radius.circular(16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.zero,
                color: Colors.grey.shade50,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text.rich(
                          TextSpan(
                            text: "Mã đặt chỗ \n",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.subText),
                            children: [
                              TextSpan(
                                  text: e.transactionInfo?.passengerNameRecord ?? "---",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.currencyText))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: InkWell(
                          onTap: () {
                            context.push(ReservationDetailPage.route,
                                extra: ReservationDetailPageViewMode.fromFlightItemDetail(flightItemDetail: e));
                          },
                          child: SizedBox(
                            height: 40,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(1, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Center(child: Text("Xem đặt chỗ")),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildHotelReservationInfo(BuildContext context) {
    return viewModel.hotelProductDetails.map((e) {
      return SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 46,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdInfoRow(leftText: "Khách sạn", rightText: e.hotelProduct?.propertyName ?? "")),
            ),
            SizedBox(
              height: 46,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GtdInfoRow(leftText: "Phòng", rightText: "${(e.hotelProduct?.rooms ?? []).length} phòng"),
              ),
            ),
            SizedBox(
              height: 46,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GtdInfoRow(leftText: "Khách", rightText: e.bookHotelPassengerInfo),
              ),
            ),
            GtdDashedBorder(
              borderType: BorderType.rRect,
              color: CustomColors.borderColor,
              padding: EdgeInsets.zero,
              radius: const Radius.circular(16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.zero,
                color: Colors.grey.shade50,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text.rich(
                          TextSpan(
                            text: "Mã đặt phòng \n",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.subText),
                            children: [
                              TextSpan(
                                  text: e.transactionInfo?.passengerNameRecord ?? "---",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.currencyText))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: InkWell(
                          onTap: () {
                            context.push(ReservationDetailPage.route,
                                extra: ReservationDetailPageViewMode.fromHotelProductDetail(hotelProductDetail: e));
                          },
                          child: SizedBox(
                            height: 40,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(1, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Center(child: Text("Xem chi tiết")),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }
}
