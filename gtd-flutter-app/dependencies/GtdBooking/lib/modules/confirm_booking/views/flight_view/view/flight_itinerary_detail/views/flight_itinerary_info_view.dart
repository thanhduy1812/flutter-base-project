import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_vertical_line_view/gtd_leading_vertical_line.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

import '../view_model/flight_itinerary_info_viewmodel.dart';

class FlightItineraryInfoView extends BaseView<FlightItineraryInfoViewModel> {
  const FlightItineraryInfoView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return Column(
      children: [
        viewModel.indexItem == 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Text(
                          "Hãng khai thác",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                        ),
                        const Spacer(),
                        Text(
                          viewModel.openrationAirline,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          "Điểm dừng",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                        ),
                        const Spacer(),
                        Text(
                          viewModel.stopsInfo,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: CustomColors.mainOrange.shade50,
                  child: ListTile(
                    leading: GtdAppIcon.iconNamedSupplier(iconName: "flight/icon-flight-transit.svg", width: 40),
                    title: Text(
                      viewModel.transitInfo,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: CustomColors.mainOrange),
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              SizedBox(
                  height: 24,
                  child: GtdImage.imgFromUrl(
                    viewModel.airlineLogo,
                  )),
              // GtdAppIcon.iconNamedSupplier(
              //   iconName: "/airlines/QH.svg",
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  viewModel.airlineName,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
                ),
              ),
              const Spacer(),
              Text(
                viewModel.airlineInfo,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.normalText),
              )
            ],
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.grey.shade50,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicWidth(
                  child: ListTile(
                    isThreeLine: false,
                    // dense: true,
                    title: Text(
                      viewModel.departTime,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                    ),
                    subtitle: Text(
                      viewModel.departDate,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text(
                      viewModel.departLocation,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                    ),
                    subtitle: Text(
                      viewModel.departAirport,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: GtdLeadingVerticalLine(
            linePadding: const EdgeInsets.only(top: 4, bottom: 4, left: 16),
            child: Row(
              children: [
                Text(
                  viewModel.duration,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: CustomColors.mainOrange),
                ),
                const Spacer(),
                Text(
                  viewModel.cabinClassType,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.normalText),
                ),
                const SizedBox(
                  width: 8,
                ),
                Material(
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: AppColors.mainColor.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        viewModel.cabinClassCode,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.normalText),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.grey.shade50,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicWidth(
                  child: ListTile(
                    isThreeLine: false,
                    // dense: true,
                    title: Text(
                      viewModel.destinationTime,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                    ),
                    subtitle: Text(
                      viewModel.destinationDate,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text(
                      viewModel.destinationLocation,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                    ),
                    subtitle: Text(
                      viewModel.destinationAirport,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
