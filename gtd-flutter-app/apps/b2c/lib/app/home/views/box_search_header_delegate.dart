import 'dart:math';

import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:new_gotadi/app/home/views/top_galleries.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/combo/form_search/view_controller/search_combo_page.dart';
import 'package:gtd_booking/modules/combo/form_search/view_model/search_combo_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/view_controller/search_flight_page.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_controller/search_hotel_page.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/search_hotel_page_viewmodel.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';

class BoxSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Opacity(
            opacity: 1 - shrinkPercentage,
            child: _buildInformationWidget(context),
          ),
        )
      ],
    );
  }

  Widget _buildInformationWidget(BuildContext context) => ClipRect(
        child: OverflowBox(
          maxHeight: double.infinity,
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const TopGalleries(),
                  Transform.translate(
                      offset: const Offset(0, -15),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.08),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                context.push(SearchFlightPage.route);
                              },
                              child: _headerButton(
                                iconName: "flight.svg",
                                title: "Vé máy bay",
                                tintColor: AppColors.mainColor,
                              ),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                SearchHotelPageViewModel viewModel = SearchHotelPageViewModel();
                                context.push(SearchHotelPage.route, extra: viewModel);
                              },
                              child: _headerButton(
                                  iconName: "hotel.svg",
                                  title: "Khách sạn",
                                  tintColor: const Color.fromRGBO(243, 68, 22, 1)),
                            )),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  SearchComboPageViewModel viewModel = SearchComboPageViewModel();
                                  context.push(SearchComboPage.route, extra: viewModel);
                                },
                                child: _headerButton(
                                    iconName: "combo.svg",
                                    title: "Combo",
                                    tintColor: const Color.fromRGBO(12, 176, 255, 1)),
                              ),
                            ),
                            // Expanded(
                            //   child: _headerButton(iconName: "tour.svg", title: "Vui Chơi", tintColor: Colors.amber),
                            // ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 269;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  Widget _headerButton({required String iconName, required String title, required Color tintColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: tintColor,
          margin: EdgeInsets.zero,
          elevation: 0,
          // decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.green),
          shape: const CircleBorder(),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GtdAppIcon.iconNamedSupplier(iconName: iconName, width: 32, height: 32),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
