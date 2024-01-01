import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_checkout_content_viewmodel.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_select_field.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../cubit/flight_checkout_cubit.dart';
import '../view_model/checkout_traveller_form_vm.dart';
import 'input_passenger_view.dart';

class BoxContactInfo extends StatelessWidget {
  final CheckoutTravellerFormVM contactForm;
  const BoxContactInfo({super.key, required this.contactForm});

  // bool genderSwitch = true;

  @override
  Widget build(BuildContext context) {
    ValueKey position = key as ValueKey;
    // CheckoutTravellerFormVM contactForm = BlocProvider.of<FlightCheckoutCubit>(context).contactFormSubject.value;

    switch (AppConst.shared.appScheme.appSupplier) {
      case GtdAppSupplier.vib:
        return buildSelectableContactForm(contactForm, context, position);
      case GtdAppSupplier.b2c:
        return buildInputContactForm(contactForm, context, position);

      default:
        return buildInputContactForm(contactForm, context, position);
    }
  }

  Widget buildSelectableContactForm(
      CheckoutTravellerFormVM contactForm, BuildContext context, ValueKey<dynamic> position) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thông tin liên hệ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text('Vui lòng cung cấp thông tin chính xác, để chúng tôi có thể liên lạc và hỗ trợ kịp thời',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
            ],
          ),
        ),
        Ink(
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
          child: Form(
            key: contactForm.formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdSelectField(
                    viewModel: contactForm.fullName,
                    onSelect: () => GtdPresentViewHelper.presentView<String>(
                      context: context,
                      title: "Thông tin liên hệ",
                      builder: Builder(
                        builder: (context) {
                          return InputPassengerView(
                            viewModel: contactForm.fullName,
                          );
                        },
                      ),
                      onChanged: (value) {
                        var checkoutContentViewModel = context.viewModelOf<GtdCheckoutContentViewModel>();
                        checkoutContentViewModel?.updateContact(key: position, fullName: value);
                      },
                    ),
                    rightIcon: const Icon(Icons.chevron_right),
                  ),
                ),
                const Divider(
                  color: Color.fromRGBO(241, 241, 241, 1),
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdSelectField(
                    viewModel: contactForm.phoneNumber,
                    rightIcon: const Icon(Icons.chevron_right),
                    onSelect: () => GtdPresentViewHelper.presentView<String>(
                      context: context,
                      title: "Thông tin liên hệ",
                      builder: Builder(
                        builder: (context) {
                          return InputPassengerView(
                            viewModel: contactForm.phoneNumber,
                          );
                        },
                      ),
                      onChanged: (value) {
                        BlocProvider.of<FlightCheckoutCubit>(context).updateContact(key: position, phoneNumber: value);
                      },
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromRGBO(241, 241, 241, 1),
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdSelectField(
                    viewModel: contactForm.email,
                    rightIcon: const Icon(Icons.chevron_right),
                    onSelect: () => GtdPresentViewHelper.presentView<String>(
                      context: context,
                      title: "Thông tin liên hệ",
                      builder: Builder(
                        builder: (context) {
                          return InputPassengerView(
                            viewModel: contactForm.email,
                          );
                        },
                      ),
                      onChanged: (value) {
                        BlocProvider.of<FlightCheckoutCubit>(context).updateContact(key: position, email: value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildInputContactForm(CheckoutTravellerFormVM contactForm, BuildContext context, ValueKey<dynamic> position) {
    var checkoutContentViewModel = context.viewModelOf<GtdCheckoutContentViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thông tin liên hệ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('Vui lòng cung cấp thông tin chính xác, để chúng tôi có thể liên lạc và hỗ trợ kịp thời',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
              ],
            ),
          ),
          Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  spreadRadius: 0,
                  blurRadius: 70,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Form(
              key: contactForm.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdTextField(
                      viewModel: contactForm.fullName..inputUserBehavior = GtdInputUserBehavior.typing,
                      onChanged: (value) {
                        print(value);

                        checkoutContentViewModel?.updateContact(key: position, fullName: value);
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdTextField(
                      viewModel: contactForm.phoneNumber..inputUserBehavior = GtdInputUserBehavior.typing,
                      onChanged: (value) {
                        print(value);
                        checkoutContentViewModel?.updateContact(key: position, phoneNumber: value);
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdTextField(
                      viewModel: contactForm.email..inputUserBehavior = GtdInputUserBehavior.typing,
                      onChanged: (value) {
                        print(value);
                        checkoutContentViewModel?.updateContact(key: position, email: value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget contactInfoForm(
      {TravelerInputInfoDTO? contactInputInfo, required BuildContext context, EdgeInsets? padding}) {
    return _buildContactInfoView(padding,
        fullName: contactInputInfo?.fullName ?? "",
        phoneNumber: contactInputInfo?.phoneNumber ?? "",
        email: contactInputInfo?.email ?? "");
  }

  static Widget contactInfoFormFromBookingDetail(
      {required GtdContactBookingInfo contactInputInfo, required BuildContext context, EdgeInsets? padding}) {
    return _buildContactInfoView(padding,
        fullName: contactInputInfo.fullName ?? "",
        phoneNumber: contactInputInfo.phoneNumber ?? "",
        email: contactInputInfo.email ?? "");
  }

  static Padding _buildContactInfoView(EdgeInsets? padding,
      {required String fullName, required String phoneNumber, required String email}) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: 140,
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdInfoRow(leftText: "Họ & tên", rightText: fullName),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdInfoRow(leftText: "Điện thoại", rightText: phoneNumber),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GtdInfoRow(leftText: "Email", rightText: email),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
