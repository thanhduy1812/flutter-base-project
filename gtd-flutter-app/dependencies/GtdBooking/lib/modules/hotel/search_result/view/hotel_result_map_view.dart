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
    viewModel.horizontalItemWidth = MediaQuery.of(context).size.width * .9 + 8;
    return Stack(
      children: [
        _mapLayout(),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 277,
              child: Column(
                children: [
                  _hotelHorizontalList(context),
                  _bottomOverlay(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _mapLayout() {
    return StreamBuilder(
      stream: viewModel.itemIndexStream.skip(0),
      builder: (context, snapshot) {
        return GtdFlutterMap(
          mapController: viewModel.mapController,
          initMapPoint: viewModel.initMapPoint,
          markers: viewModel.markers,
          selectedIndex: snapshot.data,
          zoom: viewModel.zoomLevel,
        );
      },
    );
  }

  SizedBox _hotelHorizontalList(BuildContext context) {
    return SizedBox(
      height: 175,
      child: ListView.separated(
        controller: viewModel.scrollController,
        physics: GtdPagingScrollPhysics(
          itemDimension: viewModel.horizontalItemWidth,
        ),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          return HotelResultCardItemView(
            viewModel: viewModel.hotelCardItemViewModels[index],
            onVisibilityChanged: (visible) {
              if (!visible) return;
              var item = viewModel.hotelCardItemViewModels[index];
              if (item.hotelItemModel.mapPoint != null) {
                viewModel.focusMapController.sink
                    .add(item.hotelItemModel.mapPoint!);
                Future.delayed(const Duration(seconds: 1)).then((_) {
                  viewModel.itemIndexStream.add(index);
                });
              }
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 8,
        ),
        itemCount: viewModel.hotelCardItemViewModels.length,
      ),
    );
  }

  Container _bottomOverlay() {
    return Container(
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
      ),
    );
  }
}
