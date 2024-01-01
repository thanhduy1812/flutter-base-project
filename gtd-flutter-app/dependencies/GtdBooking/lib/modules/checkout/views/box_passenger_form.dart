import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/base/view/gtd_input_select/gtd_input_select_cell.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_gender.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_custom_checkbox.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_date_picker_scroll/flutter_datetime_picker.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_select_field.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_switch_label.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../cubit/flight_checkout_cubit.dart';
import '../view_model/checkout_traveller_form_vm.dart';
import 'input_passenger_view.dart';

class BoxPassengerForm extends StatelessWidget {
  final CheckoutTravellerFormVM travellerForm;
  const BoxPassengerForm({super.key, required this.travellerForm});
  @override
  Widget build(BuildContext context) {
    ValueKey<int> position = key as ValueKey<int>;
    // CheckoutPageViewModel? viewModel = context.viewModelOf<CheckoutPageViewModel>();
    switch (AppConst.shared.appScheme.appSupplier) {
      case GtdAppSupplier.vib:
        return buildVibCheckoutPassengerForm(travellerForm, context, position);
      case GtdAppSupplier.b2c:
        return buildGotadiCheckoutPassengerForm(travellerForm, position);
      default:
        return buildGotadiCheckoutPassengerForm(travellerForm, position);
    }
  }

  Widget buildVibCheckoutPassengerForm(
      CheckoutTravellerFormVM travellerForm, BuildContext context, ValueKey<int> position) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(travellerForm.adultTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text('Vui lòng nhập Tiếng Việt không dấu hoặc Tiếng Anh theo thông tin CMND/CCCD/Passport',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text('checkout.gender', style: TextStyle(color: Colors.grey.shade900)).tr()),
                    GtdSwitchLabel(
                      width: 134.0,
                      height: 36.0,
                      leftDescription: 'Nam',
                      rightDescription: 'Nữ',
                      onLeftToggleActive: () {
                        BlocProvider.of<FlightCheckoutCubit>(context)
                            .updatePassenger(key: position, gender: GtdGender.male);
                      },
                      onRightToggleActive: () {
                        BlocProvider.of<FlightCheckoutCubit>(context)
                            .updatePassenger(key: position, gender: GtdGender.female);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color.fromRGBO(241, 241, 241, 1),
                height: 0,
              ),
              Form(
                key: travellerForm.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: GtdSelectField(
                        viewModel: travellerForm.lastName,
                        rightIcon: const Icon(Icons.chevron_right),
                        height: 52,
                        onSelect: () => GtdPresentViewHelper.presentView<String>(
                          context: context,
                          title: "Thông tin khách hàng",
                          builder: Builder(
                            builder: (context) {
                              return InputPassengerView(
                                viewModel: travellerForm.lastName,
                              );
                            },
                          ),
                          onChanged: (value) {
                            BlocProvider.of<FlightCheckoutCubit>(context)
                                .updatePassenger(key: position, lastName: value);
                          },
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(241, 241, 241, 1),
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: GtdSelectField(
                        viewModel: travellerForm.firstName,
                        rightIcon: const Icon(Icons.chevron_right),
                        onSelect: () => GtdPresentViewHelper.presentView<String>(
                          context: context,
                          title: "Thông tin khách hàng",
                          builder: Builder(
                            builder: (context) {
                              return InputPassengerView(
                                viewModel: travellerForm.firstName,
                              );
                            },
                          ),
                          onChanged: (value) {
                            BlocProvider.of<FlightCheckoutCubit>(context)
                                .updatePassenger(key: position, firstName: value);
                          },
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(241, 241, 241, 1),
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: GtdSelectField(
                        viewModel: travellerForm.birthDay,
                        rightIcon: const Icon(Icons.chevron_right),
                        onSelect: () =>
                            GtdDatePickerScroll.showDatePicker(context, maxTime: DateTime.now(), onConfirm: (value) {
                          BlocProvider.of<FlightCheckoutCubit>(context).updatePassenger(key: position, birthDay: value);
                        }),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(241, 241, 241, 1),
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: SizedBox(
                        height: 60,
                        child: ListTile(
                          title: const Text('checkout.setContactInfo',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15))
                              .tr(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          trailing: StreamBuilder(
                              stream: BlocProvider.of<FlightCheckoutCubit>(context).passengersStream,
                              builder: (context, snapshot) {
                                return GtdCheckbox(
                                  onChanged: (value) {
                                    BlocProvider.of<FlightCheckoutCubit>(context)
                                        .updatePassenger(key: position, usedForContact: value);
                                  },
                                  value: travellerForm.isContact,
                                  gradient: GtdColors.appGradient(context),
                                );
                              }),
                          minLeadingWidth: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildGotadiCheckoutPassengerForm(CheckoutTravellerFormVM travellerForm, ValueKey<int> position) {
    return GtdInputSelectCell(
      key: position,
      title: travellerForm.adultTitle,
      subTitle: travellerForm.shortInfoPassenger,
      hasData: travellerForm.firstName.text.isNotEmpty,
      defaultSubTitle: "Nhập thông tin",
    );
  }

  static Widget pasengerInfoForm(TravelerInputInfoDTO travelerInputInfoDTO, BuildContext context) {
    return GtdInputSelectCell(
      title: "${travelerInputInfoDTO.title} ${travelerInputInfoDTO.isPresentHotel ? "(Đại diện phòng)" : ""}",
      subTitle: travelerInputInfoDTO.getFullName,
      hasData: travelerInputInfoDTO.firstName.isNotEmpty,
      defaultSubTitle: "Nhập thông tin",
    );
  }
}
