import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_item_summary_list_info.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_gradient_icon.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';


class BoxFlightInformation extends StatelessWidget {
  final List<GtdFlightItemDetail> flighItems;
  const BoxFlightInformation({super.key, required this.flighItems});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(0)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => GtdPresentViewHelper.presentView(
              context: context,
              title: 'checkout.flightInfo'.tr(),
              isFullScreen: false,
              builder: Builder(
                builder: (context) => CustomScrollView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [FlightItemSummaryListInfo.buildVerticalListFlightItems(flighItems)],
                ),
              )),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GtdGradientSvg(
                image: GtdImage.svgFromSupplier(assetName: "assets/icons/flight/plane.svg"),
                gradient: GtdColors.appGradient(context),
                width: 23,
                height: 23,
              ),
            ),
            title: const Text('checkout.flightInfo', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)).tr(),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
          ),
        ));
  }
}
