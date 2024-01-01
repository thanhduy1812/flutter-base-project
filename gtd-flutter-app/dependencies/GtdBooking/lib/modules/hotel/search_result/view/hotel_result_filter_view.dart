import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_hotel_filter_type.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio_title.dart';

import '../view_model/hotel_filter_item_vm.dart';
import '../view_model/hotel_result_filter_viewmodel.dart';

class HotelResultFilterView extends BaseView<HotelResultFilterViewModel> {
  final GtdCallback<List<List<HotelFilterItemVM>>>? onApplyFilter;
  const HotelResultFilterView({super.key, required super.viewModel, this.onApplyFilter});

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          ColoredBox(
            color: Colors.white,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                    hintText: 'Nhập tên khách sạn',
                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.grey.shade50,
              child: CustomScrollView(
                // slivers: [buildCheckBoxList(), buildSlideBar()],
                slivers: [
                  SliverList.separated(
                    itemCount: viewModel.groupListItems.length,
                    itemBuilder: (context, index) {
                      var groupList = viewModel.groupListItems[index];
                      if (groupList.first.data.filterType == GtdHotelFilterType.prices ||
                          groupList.first.data.filterType == GtdHotelFilterType.propertyDistance) {
                        return buildSlideBar(
                          groupList,
                          onUpdate: () {
                            setState(
                              () {},
                            );
                          },
                        );
                      } else {
                        return buildCheckBoxList(
                          groupList,
                          onUpdate: () {
                            setState(
                              () {},
                            );
                          },
                        );
                      }
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GtdButton(
                      text: "Đặt lại",
                      height: 50,
                      colorText: Colors.black,
                      border: const Border.fromBorderSide(
                        BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      borderRadius: 25,
                      onPressed: (value) {
                        print("Đặt lại");
                        setState(
                          () {
                            viewModel.groupListItems.flattened.map((e) => e.isSelected = false).toList();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: GtdButton(
                      text: "Áp dụng",
                      isEnable: viewModel.isEnableApplyButton,
                      colorText: Colors.white,
                      color: AppColors.mainColor,
                      height: 50,
                      borderRadius: 25,
                      onPressed: (value) {
                        context.pop();
                        onApplyFilter?.call(viewModel.groupListItems);
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  Widget buildCheckBoxList(List<HotelFilterItemVM> items, {GtdVoidCallback? onUpdate}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                items.first.data.filterType.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return SizedBox(
                  height: 35,
                  child: Center(
                    child: Row(
                      children: [
                        GtdRadioTitle(
                          label: item.itemTitle,
                          value: item.isSelected,
                          groupValue: true,
                          selectedIcon: const Icon(
                            Icons.check_box_rounded,
                            color: Colors.green,
                          ),
                          unselectedIcon: Icon(
                            Icons.check_box_outline_blank_rounded,
                            color: Colors.grey.shade300,
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                if (item.data.filterType.requestType == FilterRequestType.range &&
                                    item.data.value is double) {
                                  int indexItem = items.indexOf(item);
                                  var selectedItems = items.where((element) => element.isSelected).toList();
                                  var minSelectedIndex = items.indexOf(selectedItems.firstOrNull ?? item);
                                  var maxSelectedIndex = items.indexOf(selectedItems.lastOrNull ?? item);
                                  var rangeIndexes = {indexItem, minSelectedIndex, maxSelectedIndex}.toList();
                                  rangeIndexes.sort();

                                  if (item.isSelected == false && rangeIndexes.length > 1) {
                                    items
                                        .getRange(rangeIndexes.first, rangeIndexes.last)
                                        .map((e) => e.isSelected = true)
                                        .toList();
                                    item.isSelected = true;
                                  } else if (item.isSelected == true && rangeIndexes.length > 1) {
                                    items
                                        .getRange(rangeIndexes.first, rangeIndexes.last)
                                        .map((e) => e.isSelected = true)
                                        .toList();
                                    if (indexItem == rangeIndexes.first || indexItem == rangeIndexes.last) {
                                      item.isSelected = false;
                                    }
                                  } else {
                                    item.isSelected = !item.isSelected;
                                  }
                                } else {
                                  item.isSelected = !item.isSelected;
                                }

                                onUpdate?.call();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      }),
    );
  }

  Widget buildSlideBar(List<HotelFilterItemVM> items, {GtdVoidCallback? onUpdate}) {
    RangeValues currentRangeValues = RangeValues(items.first.data.from, items.first.data.to);
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items.first.data.filterType.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  currentRangeValues.end == items.first.data.to
                      ? "Tất cả mức giá"
                      : "Từ ${currentRangeValues.start} đến ${currentRangeValues.end}",
                  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.currencyText, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          RangeSlider(
            values: currentRangeValues,
            max: items.first.data.to,
            divisions: 10,
            labels: RangeLabels(
              currentRangeValues.start.round().toString(),
              currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                currentRangeValues = values;
                // onUpdate?.call();
              });
            },
          ),
        ],
      );
    });
  }
}
