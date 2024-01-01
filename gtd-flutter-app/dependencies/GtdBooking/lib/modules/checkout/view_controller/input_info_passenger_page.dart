import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/personal_info/view_model/nationality_list_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/view_model/saved_traveller_list_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/views/nationality_list.dart';
import 'package:gtd_booking/modules/personal_info/views/saved_traveller_list.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_date_picker_scroll/flutter_datetime_picker.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio_title.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../view_model/input_info_passenger_page_viewmodel.dart';

class InputInfoPassengerPage extends BaseStatelessPage<InputInfoPassengerPageViewModel> {
  static const String route = "/inputInfoPassengerPage";
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
  InputInfoPassengerPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        key: GlobalKey(),
        children: [
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () => GtdPresentViewHelper.presentView(
                  title: "Danh sách khách",
                  hasInsetBottom: false,
                  contentPadding: const EdgeInsets.all(0),
                  context: pageContext,
                  builder: Builder(
                    builder: (context) {
                      return SavedTravellerList(
                        viewModel: SaveTravellerListViewModel(travellers: viewModel.savedTravellers),
                        onSelect: (value) {
                          Navigator.pop(context);
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                          setState(
                            () {
                              viewModel.updateTraveller(value);
                            },
                          );
                        },
                      );
                    },
                  )),
              child: Ink(
                decoration: BoxDecoration(gradient: AppColors.appGradient),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                      child: GtdAppIcon.iconNamedSupplier(iconName: "icon-saved-passenger.svg"),
                    ),
                    const Text(
                      "Danh sách khách quen đã lưu",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: "Thông tin khách \n",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                          TextSpan(
                              text:
                                  "Vui lòng cung cấp thông tin chính xác, để chúng tôi có thể liên lạc và hỗ trợ kịp thời",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                        ]),
                      ),
                    ),
                  ),
                  buildPassengerInputInfo(pageContext),
                  viewModel.isShowMemberShip ? buildMembership(pageContext) : const SliverToBoxAdapter(),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
                  SliverToBoxAdapter(
                    child: SizedBox(
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
                                  setState(
                                    () {
                                      viewModel.resetInputForm();
                                    },
                                  );
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
                                        pageContext.pop(viewModel.finalTravelerInfoDTO);
                                      },
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 200,
                  ))
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  SliverToBoxAdapter buildMembership(BuildContext pageContext) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: "Tài khoản khách hàng thân thiết",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                ]),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdTextField(
                      height: 61,
                      viewModel: GtdInputTextFieldVM(
                          label: "Chọn từ loại tài khoản", inputUserBehavior: GtdInputUserBehavior.selection),
                      rightIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      onSelect: () => GtdPresentViewHelper.presentView<String>(
                        title: "Membership Cards",
                        isFullScreen: false,
                        context: pageContext,
                        builder: Builder(
                          builder: (context) {
                            return SizedBox(
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    String membershipName = "VN AIRLINE";
                                    String membershipValue = "abcdxyz";
                                    return InkWell(
                                      onTap: () => Navigator.of(context).pop(membershipValue),
                                      child: ListTile(
                                        title: Text(membershipName),
                                        subtitle: Text(membershipValue),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const Divider(),
                                  itemCount: 5),
                            );
                          },
                        ),
                        onChanged: (result) {
                          print(result);
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdTextField(
                      height: 61,
                      viewModel: GtdInputTextFieldVM(
                          label: "Nhập số thẻ thành viên", inputValidateBehavior: GtdInputValidateBehavior.none),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildPassengerInputInfo(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(0),
                elevation: 0,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GtdRadioTitle(
                              label: "Nam",
                              padding: const EdgeInsets.all(8),
                              groupValue: viewModel.isMale,
                              value: true,
                              onChanged: ((value) {
                                setState(
                                  () {
                                    viewModel.isMale = value;
                                    viewModel.validateForm();
                                  },
                                );
                              })),
                          GtdRadioTitle(
                              label: "Nữ",
                              padding: const EdgeInsets.all(8),
                              groupValue: viewModel.isMale,
                              value: false,
                              onChanged: ((value) {
                                setState(
                                  () {
                                    viewModel.isMale = value;
                                    viewModel.validateForm();
                                  },
                                );
                              })),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var passengerSingleInfo = viewModel.passengerInfos[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Ink(
                              color: Colors.white,
                              child: GtdTextField(
                                height: 61,
                                viewModel: passengerSingleInfo,
                                rightIcon: passengerSingleInfo.inputUserBehavior == GtdInputUserBehavior.selection
                                    ? const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      )
                                    : null,
                                onChanged: (value) {
                                  passengerSingleInfo.text = value;
                                  viewModel.validateForm();
                                },
                                onSelect: () {
                                  if (passengerSingleInfo is GtdSelectDateTextFieldVM) {
                                    GtdDatePickerScroll.showDatePicker(context,
                                        maxTime: passengerSingleInfo.maxDate,
                                        minTime: passengerSingleInfo.minDate,
                                        currentTime: passengerSingleInfo.selectedDate, onConfirm: (value) {
                                      setState(
                                        () {
                                          passengerSingleInfo.selectedDate = value;
                                          viewModel.validateForm();
                                        },
                                      );
                                    });
                                  } else {
                                    return GtdPresentViewHelper.presentView<String>(
                                      title: passengerSingleInfo.label,
                                      contentPadding: EdgeInsets.zero,
                                      hasInsetBottom: false,
                                      context: context,
                                      builder: Builder(
                                        builder: (context) {
                                          return NationalityList(
                                            viewModel: NationalityListViewModel(countries: viewModel.countries),
                                            onSelect: (value) {
                                              Navigator.pop(context);

                                              setState(
                                                () {
                                                  passengerSingleInfo.text = value.model.name ?? "";
                                                  viewModel.validateForm();
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      onChanged: (result) {
                                        print("selected passenger field");
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: viewModel.passengerInfos.length),
                  ],
                ),
              ),
              (viewModel.travelerInputInfoDTO?.infoType == TravelerInputInfoType.presenterHotel ||
                      viewModel.travelerInputInfoDTO?.infoType == TravelerInputInfoType.travelerCombo)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GtdRadioTitle(
                            label: "Đại diện nhận phòng",
                            unselectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox.svg"),
                            selectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox-active.svg"),
                            value: true,
                            groupValue: viewModel.isPresentHotel,
                            onChanged: (value) {
                              setState(() => viewModel.isPresentHotel = !viewModel.isPresentHotel);
                            },
                          ),
                          const Spacer()
                        ],
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GtdRadioTitle(
                      label: "Đặt làm thông tin liên hệ",
                      unselectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox.svg"),
                      selectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox-active.svg"),
                      value: true,
                      groupValue: viewModel.isUseForContact,
                      onChanged: (value) {
                        setState(() => viewModel.isUseForContact = !viewModel.isUseForContact);
                      },
                    ),
                    const Spacer()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GtdRadioTitle(
                      label: "Lưu thông tin hành khách",
                      unselectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox.svg"),
                      selectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox-active.svg"),
                      value: true,
                      groupValue: viewModel.isSaveTraveller,
                      onChanged: (value) {
                        setState(() => viewModel.isSaveTraveller = !viewModel.isSaveTraveller);
                      },
                    ),
                    const Spacer()
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
