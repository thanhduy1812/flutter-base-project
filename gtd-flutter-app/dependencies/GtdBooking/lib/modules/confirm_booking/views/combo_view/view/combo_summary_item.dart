import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/combo_view/view_model/combo_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_summary_item.dart';
import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view/hotel_summary_item.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

class ComboSummaryItem extends BaseView<ComboSummaryItemViewModel> {
  const ComboSummaryItem({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: ListTile(
        leading: const Icon(Icons.arrow_drop_down_sharp),
        title: Text("Combo bạn đã chọn",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
        subtitle: Text.rich(TextSpan(
            text: "${viewModel.flightInfo} \n",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
            children: [TextSpan(text: viewModel.hotelInfo)])),
        onTap: () {
          GtdPresentViewHelper.presentSheet(
              title: "Combo đã chọn",
              context: context,
              builder: Builder(
                builder: (context) {
                  // return const SizedBox(height: 400);
                  return SafeArea(
                    child: Column(
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...viewModel.flightItemViewModels.map((e) => FlightSummaryItem(viewModel: e)),
                              ...[HotelSummaryItem(viewModel: viewModel.hotelItemViewModel)]
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
        },
      ),
    );
  }
}
