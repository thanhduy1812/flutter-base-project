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
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/loading/flight_item_child_loading.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shimmer/shimmer.dart';

class ItemFlightComponent<T> extends BaseView<ItemFlightComponentViewModel> {
  final ValueChanged<GtdFlightItem?> onTab;
  final ValueChanged<GtdFlightItem?> onPressed;

  const ItemFlightComponent({
    super.key,
    required super.viewModel,
    required this.onTab,
    required this.onPressed,
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
    final isLoading = (selectItemState.flightItem.groupId == viewModel.groupItem.groupId &&
        selectItemState.loadingStatus == FlightSelectItemStatus.loading);
    final isSelected = viewModel.groupItem == viewModel.groupItemSelected;
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration:
          const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12)), boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.05),
          spreadRadius: .2,
          blurRadius: 5,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ]),
      child: Column(children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (selectItemState.loadingStatus == FlightSelectItemStatus.success && !isSelected) {
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
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 96,
                            maxHeight: 40,
                          ),
                          child: GtdImage.imgFromUrl(viewModel.groupItem.flightItemInfo?.airlineLogo ?? ""),
                        ),
                        const SizedBox(
                          width: 37,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(timeFormat.format((viewModel.groupItem.flightItemInfo?.originDateTime)!),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade900)),
                                    Text('${viewModel.groupItem.flightItemInfo?.originLocation?.locationCode}',
                                        style: TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey.shade900)),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // SvgPicture.asset(GtdString.pathForAsset(
                                      //     BookingConst.shared.assetPackage,
                                      //     "assets/icons/flight/line_item_flight.svg")),
                                      Text(
                                        '${viewModel.groupItem.flightItemInfo?.journeyDurationDate()} ',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade400,
                                      ),
                                      Text(
                                        "Bay thẳng",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(timeFormat.format((viewModel.groupItem.flightItemInfo?.destinationDateTime)!),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade900)),
                                    Text('${viewModel.groupItem.flightItemInfo?.destinationLocation?.locationCode}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400, fontSize: 13, color: Colors.grey.shade900)),
                                  ],
                                ),
                              ],
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
                margin: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 16),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Hạng vé', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                    // const Text(
                                    //   'flight.item.cabinClassName',
                                    //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                    // ).tr(gender: groupItem.cabinOptions?.first.cabinClassName),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${intl.NumberFormat.decimalPattern().format(viewModel.groupItem.flightItemPriceInfo?.price)} đ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 16)),
                                    const Text(
                                      'flight.item.cabinClassName',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ).tr(gender: viewModel.groupItem.cabinOptions?.first.cabinClassName),
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
                                  : Text('${viewModel.groupItem.totalPricedItinerary} lựa chọn',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              Transform.rotate(
                                angle: !isSelected ? 0 : 3.14,
                                child: GtdImage.svgFromSupplier(assetName: "assets/icons/down.svg"),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
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
                              margin: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${viewModel.groupItem.cabinOptions?[index].adultPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.primary,
                                                fontSize: 20)),
                                        Text(
                                            'flight.item.cabinClassName'
                                                .tr(gender: viewModel.groupItem.cabinOptions?[index].cabinClassName),
                                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  GtdButton(
                                      text: 'Chọn',
                                      height: 30,
                                      borderRadius: 15,
                                      gradient: GtdColors.appGradient(context),
                                      onPressed: (val) {
                                        GtdAirlineCabinClass? cabinOption = viewModel.groupItem.cabinOptions?[index];
                                        viewModel.groupItem.chooseCabinClass(cabinOption!);
                                        onPressed(viewModel.groupItem);
                                      })
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey.shade100),
                          ],
                        );
                      }))
              : const SizedBox(width: double.infinity),
        )
      ]),
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
                                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 65,
                                height: 14,
                                decoration: const BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 130,
                                height: 12,
                                decoration: const BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
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
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 16),
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
                                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 16,
                                  width: 80,
                                  decoration: const BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
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
                                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
