import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

import '../view_model/flight_summary_item_viewmodel.dart';

class FlightSummaryVerticalItem extends BaseView<FlightSummaryItemViewModel> {
  const FlightSummaryVerticalItem({super.key, required super.viewModel});
  @override
  Widget buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        children: [
          ListTile(
            title: Text(viewModel.titleHeader,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)))
                .tr(),
            contentPadding: EdgeInsets.zero,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Wrap(
                direction: Axis.vertical,
                spacing: 10,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 96,
                      maxHeight: 40,
                    ),
                    child: GtdImage.imgFromUrl(viewModel.airlineLogo),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(viewModel.airlineInfo, style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(viewModel.transitionTitle, style: TextStyle(color: Colors.grey.shade500))
                    ],
                  )
                ],
              )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(viewModel.originCode,
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                      Text(viewModel.originTime, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GtdImage.svgFromSupplier(
                            assetName: "assets/icons/flight/flight-single.svg", color: Colors.grey.shade500),
                        Text(viewModel.duration, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(viewModel.destinationCode,
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                      Text(viewModel.destinationTime,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                    ],
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
