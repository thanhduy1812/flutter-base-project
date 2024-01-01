import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/hotel_input_room_passenger_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_box_info.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import 'combo_room_picker/view/combo_room_picker_view.dart';

class ComboInputRoomPassengerView extends BaseView<HotelInputRoomPassengerViewModel> {
  final GlobalKey<AnimatedListState> listRoomAnimatedKey = GlobalKey();
  final ScrollController controller = ScrollController(keepScrollOffset: true);
  final GtdCallback<HotelInputRoomPassengerViewModel>? onConfirm;
  ComboInputRoomPassengerView({super.key, required super.viewModel, this.onConfirm});

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setStateInputRoom) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: Colors.white,
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GtdBoxInfo(
                        title: "Phòng",
                        subTitle: "${viewModel.rooms.length}",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: GtdBoxInfo(
                        title: "Tổng khách",
                        subTitle:
                            "${viewModel.totalAdultCount + viewModel.totalChildCount + viewModel.totalInfantCount}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.custom(
              controller: controller,
              cacheExtent: 100,
              childrenDelegate: SliverChildListDelegate([
                AnimatedList(
                  key: listRoomAnimatedKey,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  initialItemCount: viewModel.rooms.length,
                  itemBuilder: (context, index, animation) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SlideTransition(
                        position: animation.drive(Tween(begin: const Offset(2, 0.0), end: const Offset(0.0, 0.0))
                            .chain(CurveTween(curve: Curves.easeInOut))),
                        child: ComboRoomPickerView(
                          viewModel: viewModel.rooms[index],
                          onRemove: () {
                            if (viewModel.rooms.length > 1) {
                              var removeRoom = viewModel.rooms[index];
                              viewModel.removeRoomAtIndex(index);
                              listRoomAnimatedKey.currentState!.removeItem(index, (context, animation) {
                                return SlideTransition(
                                  position: animation.drive(
                                      Tween(begin: const Offset(2, 0.0), end: const Offset(0.0, 0.0))
                                          .chain(CurveTween(curve: Curves.easeInOut))),
                                  child: ComboRoomPickerView(viewModel: removeRoom),
                                );
                              });
                            }
                            setStateInputRoom(() => {});
                          },
                          onNotifyChanged: () {
                            setStateInputRoom(() => {});
                          },
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.jumpTo(controller.position.maxScrollExtent);
                    viewModel.insertNewRoom();
                    listRoomAnimatedKey.currentState!
                        .insertItem(viewModel.rooms.length - 1, duration: const Duration(milliseconds: 500));
                    setStateInputRoom(() => {});
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.grey.shade900,
                  ),
                  label: Text(
                    'Thêm phòng',
                    style: TextStyle(color: Colors.grey.shade900),
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                  ),
                )
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GtdButton(
              text: "Xác nhận",
              color: AppColors.mainColor,
              isEnable: viewModel.isEnableButton,
              height: 50,
              borderRadius: 25,
              onPressed: (value) {
                onConfirm?.call(viewModel);
                context.pop();
              },
            ),
          )
        ],
      );
    });
  }
}

extension ComboInputRoomPassengerViewHelper on ComboInputRoomPassengerView {
  static void showComboPickerRoomAndPassengers(
      {required BuildContext pageContext,
      required HotelInputRoomPassengerViewModel savedHotelInputViewModel,
      GtdCallback<HotelInputRoomPassengerViewModel>? onConfirm}) {
    var hotelInputViewModel = savedHotelInputViewModel.copyWith();
    GtdPresentViewHelper.presentView(
        title: "Số phòng & khách",
        context: pageContext,
        contentPadding: EdgeInsets.zero,
        hasInsetBottom: false,
        contentColor: Colors.grey.shade100,
        builder: Builder(
          builder: (context) {
            return ComboInputRoomPassengerView(
              viewModel: hotelInputViewModel,
              onConfirm: (value) {
                onConfirm?.call(value);
              },
            );
          },
        ));
  }
}
