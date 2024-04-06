library dialog_itinerary;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_select_item_cubit.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_select_item_state.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/item_flight_component_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_airline_cabin_class.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/loading/flight_item_child_loading.dart';
import 'package:shimmer/shimmer.dart';

class ItemFlightComponent<T> extends BaseView<ItemFlightComponentViewModel> {
  final ValueChanged<GtdFlightItem?> onTab;
  final ValueChanged<({GtdFlightItem? flightItem, GtdAirlineCabinClass? cabinOption})>
      onPressed;
  final bool isRoundTrip;

  const ItemFlightComponent({
    super.key,
    required super.viewModel,
    required this.onTab,
    required this.onPressed,
    this.isRoundTrip = false,
  });

  @override
  Widget buildWidget(BuildContext context) {
    if (viewModel.viewType == ItemFlightType.data) {
      return _buildFlightComponent(context);
    }
    if (viewModel.viewType == ItemFlightType.loading) {
      return _buildLoadingFlightItem(context);
    }
    return const SizedBox();
  }

  Widget _buildFlightComponent(BuildContext context) {
    DateFormat timeFormat = DateFormat("HH:mm");
    final selectItemBloc = BlocProvider.of<FlightSelectItemCubit>(context);
    final selectItemState = selectItemBloc.state;
    final isLoading =
        (selectItemState.flightItem.groupId == viewModel.groupItem.groupId &&
            selectItemState.loadingStatus == FlightSelectItemStatus.loading);
    final isSelected = viewModel.groupItem == viewModel.groupItemSelected;
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            spreadRadius: .2,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (selectItemState.loadingStatus ==
                      FlightSelectItemStatus.success &&
                  !isSelected) {
                onTab(viewModel.groupItem);
              }
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    runSpacing: 16,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _airlineLogo(),
                              _flightCodeInfo(),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _flightSegmentText(),
                              if (isRoundTrip)
                                Text(
                                  'Giá khứ hồi',
                                  style: TextStyle(
                                    color: GtdColors.slateGrey,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
                    bottom: 8,
                  ),
                  child: Column(
                    children: [
                      _flightRoute(),
                      _flightTime(timeFormat),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade100),
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 5,
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: 20,
                          children: [
                            isSelected
                                ? const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hạng vé',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      // const Text(
                                      //   'flight.item.cabinClassName',
                                      //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                      // ).tr(gender: groupItem.cabinOptions?.first.cabinClassName),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${viewModel.groupItem.flightItemPriceInfo?.price?.toCurrency()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: GtdColors.pumpkinOrange,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        '${'flight.item.cabinClassName'.tr(
                                          gender: viewModel
                                              .groupItem
                                              .cabinOptions
                                              ?.first
                                              .cabinClassName,
                                        )} '
                                        '(${viewModel.groupItem.cabinOptions?.first.cabinClassCode})',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: GtdColors.inkBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          runSpacing: 26,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  isSelected
                                      ? const SizedBox()
                                      : Text(
                                          '${viewModel.groupItem.totalPricedItinerary} lựa chọn',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                GtdColors.appMainColor(context),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: Transform.rotate(
                                      angle: !isSelected ? 0 : 3.14,
                                      child: GtdImage.svgFromSupplier(
                                        assetName: "assets/icons/down.svg",
                                        color: GtdColors.appMainColor(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: isSelected
                ? (isLoading
                    ? const GtdFlightItemChildLoading()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: viewModel.groupItem.cabinOptions?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 5,
                                  bottom: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${viewModel.groupItem.cabinOptions?[index].adultPrice}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: GtdColors.pumpkinOrange,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            '${'flight.item.cabinClassName'.tr(
                                              gender: viewModel
                                                  .groupItem
                                                  .cabinOptions?[index]
                                                  .cabinClassName,
                                            )} '
                                            '(${viewModel.groupItem.cabinOptions?[index].cabinClassCode})',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: GtdColors.inkBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GtdButton(
                                      text: 'Chọn vé',
                                      height: 36,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      borderRadius: 18,
                                      gradient: GtdColors.appGradient(context),
                                      onPressed: (val) {
                                        GtdAirlineCabinClass? cabinOption =
                                            viewModel
                                                .groupItem.cabinOptions?[index];
                                        viewModel.groupItem.chooseCabinClass(
                                          cabinOption!,
                                        );
                                        onPressed((
                                          flightItem: viewModel.groupItem,
                                          cabinOption: cabinOption,
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey.shade100),
                            ],
                          );
                        },
                      ))
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Row _flightTime(DateFormat timeFormat) {
    final info = viewModel.groupItem.flightItemInfo;
    int difInDays = 0;
    if (info != null) {
      if (info.destinationDateTime != null && info.originDateTime != null) {
        if (!info.destinationDateTime!.isSameDate(info.originDateTime!)) {
          difInDays = info.originDateTime!.difInDays(info.destinationDateTime);
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            timeFormat.format((info?.originDateTime)!),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        Text(
          '${info?.journeyDurationDate()} ',
          style: TextStyle(
            fontSize: 12,
            color: GtdColors.inkBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeFormat.format((info?.destinationDateTime)!),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.grey.shade900,
                ),
              ),
              if (difInDays > 0)
                Text(
                  '+${difInDays.toString()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Row _flightRoute() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${viewModel.groupItem.flightItemInfo?.originLocation?.locationCode}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade900,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Divider(
                  thickness: 1,
                  height: 1,
                  color: GtdColors.stormGray,
                ),
                Container(
                  width: 30,
                  height: 24,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Center(
                    child: GtdImage.svgFromSupplier(
                      assetName: 'assets/icons/flight/flight-single.svg',
                      color: GtdColors.stormGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          '${viewModel.groupItem.flightItemInfo?.destinationLocation?.locationCode}',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }

  Text _flightSegmentText() {
    final segmentCount =
        viewModel.groupItem.flightItemInfo?.flightSegments?.length ?? 0;
    String title = '';
    if (segmentCount > 1) {
      title = '${segmentCount - 1} Điểm dừng';
    } else {
      title = 'Bay thẳng';
    }

    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Text _flightCodeInfo() {
    return Text(
      viewModel.getFlightCodeText(),
      style: TextStyle(
        fontSize: 12,
        color: GtdColors.slateGrey,
      ),
    );
  }

  Container _airlineLogo() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 84,
        maxHeight: 20,
      ),
      child: GtdImage.imgFromUrl(
        viewModel.groupItem.flightItemInfo?.airlineLogo ?? "",
      ),
    );
  }

  Widget _buildLoadingFlightItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 32,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 65,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 130,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade100),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 5,
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 20,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                width: 115,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 16,
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        runSpacing: 26,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Container(
                                  height: 20,
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
