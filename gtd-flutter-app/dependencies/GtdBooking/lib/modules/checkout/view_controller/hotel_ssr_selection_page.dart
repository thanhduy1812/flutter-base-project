import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/view_model/hotel_ssr_selection_page_viewmodel.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio_title.dart';

class HotelSSRSelectionPage extends BaseStatelessPage<HotelSSRSelectionPageViewModel> {
  static const String route = "/hotelSSRSelectionPage";
  const HotelSSRSelectionPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          "Lưu ý: Các yêu cầu của bạn không được đảm bảo trước và chỉ có thể được áp dụng tùy tình trạng  của nơi lưu trú hoặc có thể kèm thêm phụ phí",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.subText),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                StatefulBuilder(builder: (context, setState) {
                                  return ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: viewModel.initHotelSSRItems.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: GtdRadioTitle(
                                        label: viewModel.initHotelSSRItems[index].data.title,
                                        unselectedIcon:
                                            GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox.svg"),
                                        selectedIcon:
                                            GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox-active.svg"),
                                        shrinkWrap: true,
                                        value: true,
                                        groupValue: viewModel.initHotelSSRItems[index].isSelected,
                                        onChanged: (value) {
                                          setState(() => viewModel.initHotelSSRItems[index].toggle());
                                          viewModel.validateAdditional();
                                        },
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(
                                  height: 100,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Ghi chú mô tả thêm",
                                        hintStyle: TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            borderSide: BorderSide(width: 1, color: AppColors.subText))),
                                    onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                    scrollPadding:
                                        EdgeInsets.only(bottom: MediaQuery.of(pageContext).viewInsets.bottom),
                                    cursorHeight: 22,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    expands: true,
                                    maxLines: null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GtdButton(
                          text: "Xoá",
                          height: 50,
                          color: Colors.white,
                          colorText: AppColors.normalText,
                          border: const Border.fromBorderSide(
                            BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          borderRadius: 25,
                          onPressed: (value) {
                            viewModel.reset();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          flex: 1,
                          child: ListenableBuilder(
                            listenable: viewModel,
                            builder: (context, child) {
                              return GtdButton(
                                text: "Lưu",
                                isEnable: viewModel.isEnableSaveButton,
                                height: 50,
                                color: AppColors.buttonColor,
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: AppColors.buttonColor,
                                    width: 0.0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                borderRadius: 25,
                                onPressed: (value) {
                                  // pageContext.pop(viewModel.finalTravelerInfoDTO);
                                  viewModel.confirmHotelAdditional();
                                  pageContext.pop(viewModel.selectedHotelAdditionalItems);
                                },
                              );
                            },
                          )),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
