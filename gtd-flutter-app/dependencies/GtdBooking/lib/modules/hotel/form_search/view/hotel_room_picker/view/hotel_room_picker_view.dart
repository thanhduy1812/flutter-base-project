import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/hotel_room_picker/model/hotel_room_child_age.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/hotel_room_picker/view_model/hotel_room_picker_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/passenger_picker.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

class HotelRoomPickerView extends BaseView<HotelRoomPickerViewModel> {
  final GtdVoidCallback? onRemove;
  final GtdVoidCallback? onNotifyChanged;
  const HotelRoomPickerView({super.key, required super.viewModel, this.onRemove, this.onNotifyChanged});

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phòng ${viewModel.index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                InkWell(
                    onTap: () {
                      onRemove?.call();
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: GtdImage.svgFromSupplier(
                          assetName: 'assets/icons/trash.svg',
                          color: GtdColors.appMainColor(context),
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(
                  height: 62,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Người lớn\n",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: GtdColors.inkBlack,
                                ),
                              ),
                              TextSpan(
                                text: "Trên 17 tuổi",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: GtdColors.stormGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PassengerPicker(
                          defaultValue: viewModel.adult,
                          max: 9,
                          min: 1,
                          onPressed: (newValue) {
                            onNotifyChanged?.call();
                            setState(() {
                              viewModel.adult = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 62,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Trẻ em\n",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: GtdColors.inkBlack,
                                ),
                              ),
                              TextSpan(
                                text: "Từ 1 đến 17 tuổi",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: GtdColors.stormGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PassengerPicker(
                          defaultValue: viewModel.child,
                          max: 6,
                          min: 0,
                          onPressed: (newValue) {
                            onNotifyChanged?.call();
                            setState(() {
                              viewModel.child = newValue;
                              if (newValue < viewModel.roomChilds.length + 1) {
                                viewModel.roomChilds.removeLast();
                              } else {
                                viewModel.roomChilds.add(HotelRoomChildAge(position: newValue));
                              }

                              if (newValue == 0) {
                                // viewModel.childAge = null;
                                viewModel.roomChilds = [];
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                viewModel.child == 0 ? const SizedBox() : const Divider(),
                viewModel.child == 0
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.roomChilds.length,
                        itemBuilder: (context, index) {
                          var item = viewModel.roomChilds[index];
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 500),
                            child: InkWell(
                              onTap: () {
                                _showAgePicker(
                                  context: context,
                                  initialAge: item.age,
                                  onConfirm: (value) {
                                    onNotifyChanged?.call();
                                    setState(
                                      () {
                                        item.age = value;
                                      },
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: GtdInfoRow(
                                  leftText: "Tuổi trẻ em ${item.position}",
                                  rightText: item.age != null ? "${item.age} tuổi" : "Vui lòng chọn",
                                  rightIcon: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.mainColor,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void _showAgePicker({required BuildContext context, GtdCallback<int>? onConfirm, int? initialAge}) {
    List<int> childRangeAges = Iterable<int>.generate(16).map((e) => e + 1).toList();
    int selectedIndex = (initialAge ?? 1) - 1;
    GtdPresentViewHelper.presentView(
        context: context,
        title: "Chọn tuổi",
        isFullScreen: false,
        contentPadding: EdgeInsets.zero,
        builder: Builder(
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 32,
                      // This sets the initial item.
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedIndex,
                      ),
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(
                          () {
                            selectedIndex = selectedItem;
                          },
                        );
                      },
                      children: List<Widget>.generate(childRangeAges.length, (int index) {
                        return Center(
                            child: Text(
                          "${childRangeAges[index]} tuổi",
                          style: TextStyle(
                              color: index == selectedIndex
                                  ? AppColors.mainColor
                                  : ((index == selectedIndex + 1 || index == selectedIndex - 1)
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ));
                      }),
                    ),
                  ),
                  GtdButton(
                    text: "Xác nhận",
                    color: AppColors.mainColor,
                    height: 50,
                    borderRadius: 25,
                    onPressed: (value) {
                      onConfirm?.call(selectedIndex + 1);
                      context.pop();
                    },
                  )
                ],
              );
            });
          },
        ));
  }
}
