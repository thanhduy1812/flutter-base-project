import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_flutter_map.dart';
import 'package:gtd_utils/utils/list_view_helper/gtd_paging_scroll_physics.dart';

import '../view_model/hotel_result_map_viewmodel.dart';
import 'hotel_result_content_item/view/hotel_result_card_item_view.dart';

class HotelResultMapView extends BaseView<HotelResultMapViewModel> {
  const HotelResultMapView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: [
        GtdFlutterMap(
          mapController: viewModel.mapController,
          // markers: [GtdMarker(value: "134,300 VND", latitude: 10.8045027, longitude: 106.7910036)],
          initMapPoint: viewModel.initMapPoint,
          markers: viewModel.markers,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 277,
              child: Column(
                children: [
                  SizedBox(
                    height: 175,
                    child: ListView.separated(
                        physics: const GtdPagingScrollPhysics(itemDimension: 323 + 8),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          print("visible item $index");
                          var item = viewModel.hotelCardItemViewModels[index];
                          if (index == 0 && item.hotelItemModel.mapPoint != null) {
                            viewModel.focusMapController.sink.add(item.hotelItemModel.mapPoint!);
                          } else {
                            var centerItem = viewModel.hotelCardItemViewModels[index - 1];
                            if (centerItem.hotelItemModel.mapPoint != null) {
                              viewModel.focusMapController.sink.add(centerItem.hotelItemModel.mapPoint!);
                            }
                          }
                          print(
                              "MapPoint la:${item.hotelItemModel.mapPoint?.latitude} long:${item.hotelItemModel.mapPoint?.longitude}");
                          return HotelResultCardItemView(
                            viewModel: viewModel.hotelCardItemViewModels[index],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 8,
                            ),
                        itemCount: viewModel.hotelCardItemViewModels.length),
                  ),
                  Container(
                      height: 102,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
