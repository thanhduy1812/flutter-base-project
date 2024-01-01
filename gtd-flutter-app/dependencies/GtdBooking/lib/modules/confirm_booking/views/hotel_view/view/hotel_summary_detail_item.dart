import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view_model/hotel_summary_item_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_amenity_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tool_tip_shape/gtd_tool_tip_shape.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

class HotelSummaryDetailItem extends BaseView<HotelSummaryItemViewModel> {
  final double? width;
  const HotelSummaryDetailItem({super.key, required super.viewModel, this.width});

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
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Khách sạn đã chọn ",
                      style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      viewModel.changeHotelHeader,
                      style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Ink(
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SizedBox(
                          child: Text(
                            viewModel.titleHeader,
                            style: TextStyle(fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GtdDashedBorder(
                          color: Colors.grey.shade200,
                          dashPattern: const [2, 2],
                          customPath: (size) => Path()
                            ..moveTo(0, 0)
                            ..lineTo(size.width, 0),
                          child: const Divider(
                            color: Colors.transparent,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text.rich(TextSpan(
                                  text: "Địa chỉ \n",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                                  children: [
                                    TextSpan(
                                        text: viewModel.hotelProductDetail?.hotelProduct?.address?.lineOne ?? "",
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText))
                                  ])),
                            ),
                          ],
                        ),
                      ),
                      GtdDashedBorder(
                          color: Colors.grey.shade200,
                          dashPattern: const [2, 2],
                          customPath: (size) => Path()
                            ..moveTo(0, 0)
                            ..lineTo(size.width, 0),
                          child: const Divider(
                            color: Colors.transparent,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text.rich(TextSpan(
                                  text: "Phòng & khách \n",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                                  children: [
                                    TextSpan(
                                        text: viewModel.roomInfo,
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText))
                                  ])),
                            ),
                            // GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-change.svg", height: 24)
                          ],
                        ),
                      ),
                      GtdDashedBorder(
                          color: Colors.grey.shade200,
                          dashPattern: const [2, 2],
                          customPath: (size) => Path()
                            ..moveTo(0, 0)
                            ..lineTo(size.width, 0),
                          child: const Divider(
                            color: Colors.transparent,
                          )),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text.rich(TextSpan(
                                  text: "Nhận phòng \n",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                                  children: [
                                    TextSpan(
                                        text: viewModel.checkin,
                                        style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w600, color: CustomColors.mainOrange))
                                  ])),
                              Column(
                                children: [
                                  GtdAppIcon.iconNamedSupplier(iconName: "icon-clock-grey.svg", width: 24),
                                  const SizedBox(height: 4),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                                        borderRadius: BorderRadius.circular(100)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      child: Text(
                                        "${viewModel.nights} đêm",
                                        style: TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.boldText),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text.rich(
                                TextSpan(
                                    text: "Trả phòng \n",
                                    style:
                                        TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                                    children: [
                                      TextSpan(
                                          text: viewModel.checkout,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: CustomColors.mainOrange))
                                    ]),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GtdDashedBorder(
                          color: Colors.grey.shade200,
                          dashPattern: const [2, 2],
                          customPath: (size) => Path()
                            ..moveTo(0, 0)
                            ..lineTo(size.width, 0),
                          child: const Divider(
                            color: Colors.transparent,
                          )),
                      InkWell(
                        onTap: () {
                          GtdPresentViewHelper.presentView(
                              title: "Thông tin khách sạn",
                              context: context,
                              hasInsetBottom: false,
                              useRootContext: true,
                              contentPadding: EdgeInsets.zero,
                              builder: Builder(
                                builder: (context) {
                                  return const SizedBox();
                                  // return FlightItemDetailView(
                                  //     viewModel: FlightItemDetailViewModel(flightItemDetail: viewModel.flightItemDetail!));
                                },
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                          child: SizedBox(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    viewModel.roomType,
                                    style:
                                        TextStyle(fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 24,
                                  color: AppColors.mainColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: (viewModel.hotelRoomDetailDTO?.overviewAmenities ?? [])
                                    .map((e) => GtdAmenityView(
                                          title: e.value,
                                          leadingIcon: GtdAppIcon.iconNamedSupplier(iconName: "hotel/${e.icon}"),
                                        ))
                                    .toList(),
                              ),
                              ListTile(
                                leading: GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-room-loading.svg"),
                                contentPadding: EdgeInsets.zero,
                                horizontalTitleGap: 5,
                                title: Text(
                                  viewModel.hotelProductDetail?.hotelProduct?.rooms?.firstOrNull?.ratePlans?.firstOrNull
                                          ?.cancelPolicyTitle.title ??
                                      "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400, color: CustomColors.darkBlue, fontSize: 12),
                                ),
                                trailing: Tooltip(
                                  message: viewModel.hotelProductDetail?.hotelProduct?.rooms?.firstOrNull?.ratePlans
                                          ?.firstOrNull?.cancelPolicyTitle.description ??
                                      "",
                                  verticalOffset: 10,
                                  preferBelow: false,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  textStyle: const TextStyle(color: Colors.black),
                                  showDuration: const Duration(seconds: 5),
                                  decoration:
                                      const ShapeDecoration(shape: GtdTooltipShape(), color: Colors.white, shadows: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ]),
                                  triggerMode: TooltipTriggerMode.tap,
                                  child: GtdAppIcon.iconNamedSupplier(iconName: "icon-info-blue.svg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GtdAmenityView(
                                title: viewModel.hotelProductDetail?.hotelProduct?.rooms?.firstOrNull?.ratePlans
                                        ?.firstOrNull?.amenities?[index].name ??
                                    ""),
                            itemCount: (viewModel.hotelProductDetail?.hotelProduct?.rooms?.firstOrNull?.ratePlans
                                        ?.firstOrNull?.amenities ??
                                    [])
                                .length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
