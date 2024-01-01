import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/hotel/form_search/view/hote_input_room_passenger_view.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/passengers_room_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';

class PassengersRoomView extends BaseView<PassengersRoomViewModel> {
  const PassengersRoomView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () {
              showHotelPickerRoomAndPassengers(context, setState);
            },
            child: GtdInfoRow.seperatedRow(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: "${viewModel.savedHotelInputViewModel.rooms.length}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          children: const [TextSpan(text: " Phòng   ", style: TextStyle(fontWeight: FontWeight.w400))]),
                    ),
                    Text.rich(
                      TextSpan(
                          text: "${viewModel.savedHotelInputViewModel.totalAdultCount}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          children: const [
                            TextSpan(text: " Người lớn  ", style: TextStyle(fontWeight: FontWeight.w400))
                          ]),
                    ),
                    Text.rich(
                      TextSpan(
                          text: "${viewModel.savedHotelInputViewModel.totalChildCount}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          children: const [TextSpan(text: " Trẻ em", style: TextStyle(fontWeight: FontWeight.w400))]),
                    ),
                  ],
                ),
                color: Colors.grey.shade900),
          ),
        ),
      );
    });
  }

  void showHotelPickerRoomAndPassengers(BuildContext pageContext, StateSetter setState) {
    HotelInputRoomPassengerViewHelper.showHotelPickerRoomAndPassengers(
      pageContext: pageContext,
      savedHotelInputViewModel: viewModel.savedHotelInputViewModel,
      onConfirm: (value) {
        setState(
          () {
            viewModel.savedHotelInputViewModel = value;
          },
        );
      },
    );
  }
}
