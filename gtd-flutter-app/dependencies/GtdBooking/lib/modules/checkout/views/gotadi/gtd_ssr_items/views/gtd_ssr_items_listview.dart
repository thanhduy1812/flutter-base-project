import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_outline_select_button/view/gtd_outline_select_button.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

import '../view_model/gtd_ssr_items_list_viewmodel.dart';

class GtdSSRItemListView extends BaseView<GtdSSRItemListViewModel> {
  const GtdSSRItemListView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    var travellerAvailableItems = viewModel.travelerTupleItems;
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (listContext, index) {
          var travellerInputDTO = travellerAvailableItems[index].travelerDTO;
          var ssrItems = travellerAvailableItems[index].ssrItems;
          var itemRighTitle =
              viewModel.travelerSeletedItems.map((e) => e.selectedSsrItems).flattened.map((e) => e.ssrName).firstOrNull;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                  height: 52,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(travellerInputDTO.getFullName), Text(itemRighTitle ?? "")],
                  ),
                ),
              ),
              SizedBox(
                height: 69,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView.separated(
                    key: PageStorageKey("${viewModel.flightDirection.value}$index"),
                    scrollDirection: Axis.horizontal,
                    itemCount: ssrItems.length,
                    itemBuilder: (context, index) {
                      return GtdOutlineSelectButton(
                        viewModel: ssrItems[index],
                        onChanged: (value) {
                          ssrItems.where((element) => element != value).map(
                            (e) {
                              e.isSelected = false;
                              return e;
                            },
                          ).toList();
                          // viewModel.updateSeletedItemTraveler(
                          //     travelerKey: travellerInputDTO.travelerKey, ssrItemVMs: [value]);

                          // BlocProvider.of<FlightSsrSelectionCubit>(context).rebuildWidget();
                          BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                        },
                        itemBuilder: (context, item) {
                          return SizedBox(
                            child: Card(
                              elevation: 0,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: item.isSelected ? AppColors.mainColor : Colors.grey.shade100, width: 1)),
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                  child: Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                          text: "${item.data.ssrName} \n",
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: item.data.ssrAmount.toCurrency(),
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))
                                    ]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 16,
                    ),
                  ),
                ),
              )
            ],
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: viewModel.travellerDTOs.length);
  }
}
