import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/my_booking/view_model/my_booking_item_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';

class MyBookingFlightItem<T> extends BaseView<MyBookingItemViewModel> {
  const MyBookingFlightItem({
    super.key,
    required super.viewModel,
  });

  @override
  Widget buildWidget(BuildContext context) {
    if (viewModel.supplier == GtdAppSupplier.vib) {
      return _buildVibMyBooking(context);
    } else {
      return _buildGtdMyBooking(context);
    }
  }

  Widget _buildVibMyBooking(BuildContext context) {
    var itemBooking = viewModel.itemBooking;
    Map<String, dynamic> params = {};
    params.putIfAbsent("bookingNumber", () => itemBooking.bookingNumber);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push("/flightBookingResult", extra: params),
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            // direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GtdImage.svgFromSupplier(assetName: 'assets/icons/point-connect.svg'),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      '${itemBooking.fromCity} (${itemBooking.fromLocationCode})',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '${itemBooking.toCity} (${itemBooking.toLocationCode})',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GtdButton(
                    onPressed: (val) {},
                    text: 'myBooking.bookingStatus.${itemBooking.supplierType}'.tr(gender: itemBooking.status),
                    height: 30,
                    colorText: itemBooking.colorTextStatus(context, itemBooking.status!).statusColor,
                    borderRadius: 100,
                    color: Colors.grey.shade100,
                    fontSize: 12,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGtdMyBooking(BuildContext context) {
    var itemBooking = viewModel.itemBooking;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            GtdInfoRow(
                leftText: "Trạng thái",
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                rightWidget: Row(
                  children: [
                    const Spacer(),
                    Card(
                      color: itemBooking.colorTextStatus(context, itemBooking.status!).statusBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: itemBooking.colorTextStatus(context, itemBooking.status!).statusColor,
                              radius: 8,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'myBooking.bookingStatus.${itemBooking.supplierType}'.tr(gender: itemBooking.status),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 4),
            GtdInfoRow(
                leftText: "Mã tham chiếu",
                rightWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Flexible(
                      child: Text(
                        itemBooking.bookingNumber ?? "---",
                        style: TextStyle(
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: viewModel.itemBooking.bookingNumber!));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text("Booking number copied")));
                        },
                        child: GtdAppIcon.iconNamedSupplier(iconName: "icon-duplicate.svg", height: 24))
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GtdDashedBorder(
                  color: Colors.grey.shade200,
                  dashPattern: const [2, 2],
                  customPath: (size) => Path()
                    ..moveTo(-16, 0)
                    ..lineTo(size.width + 16, 0),
                  child: const SizedBox(width: double.infinity)),
            ),
            GtdInfoRow(
                padding: const EdgeInsets.symmetric(vertical: 4),
                leftText: "Chiều đi",
                rightText: '${itemBooking.fromCity} - ${itemBooking.toCity}'),
            GtdInfoRow(
                padding: const EdgeInsets.symmetric(vertical: 4),
                leftText: "Ngày đi",
                rightText: viewModel.departDateStr),
            viewModel.isRoundTrip
                ? GtdInfoRow(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    leftText: "Chiều về",
                    rightText: '${itemBooking.toCity} - ${itemBooking.fromCity}')
                : const SizedBox(),
            viewModel.isRoundTrip
                ? GtdInfoRow(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    leftText: "Ngày về",
                    rightText: viewModel.returnDateStr)
                : const SizedBox(),
            // GtdInfoRow(
            //     padding: const EdgeInsets.symmetric(vertical: 4),
            //     leftText: "Khách",
            //     rightText: viewModel.passengersInfo),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GtdDashedBorder(
                  color: Colors.grey.shade200,
                  dashPattern: const [2, 2],
                  customPath: (size) => Path()
                    ..moveTo(-16, 0)
                    ..lineTo(size.width + 16, 0),
                  child: const SizedBox(width: double.infinity)),
            ),
            Row(
              children: [
                const Spacer(),
                itemBooking.status == "SUCCEEDED"
                    ? Text(
                        "Yêu cầu bổ sung",
                        style: TextStyle(color: AppColors.mainColor),
                      )
                    : const SizedBox(),
                const SizedBox(width: 16),
                Text(
                  "Xem chi tiết",
                  style: TextStyle(color: AppColors.mainColor),
                ),
                const SizedBox(width: 16),
              ],
            )
          ],
        ),
      ),
    );
  }
}
