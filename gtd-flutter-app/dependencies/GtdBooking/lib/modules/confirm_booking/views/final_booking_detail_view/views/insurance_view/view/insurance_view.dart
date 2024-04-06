import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/checkout/view_model/flight_ssr_selection_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/insurance_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/insurance_view/view_model/insurance_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_plans_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_insurance_type.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_html_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio_title.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class InsuranceView extends BaseView<InsuranceViewModel> {
  final GtdCallback<InsuranceViewModel>? onSelect;
  final GtdCallback? onChangePackage;
  const InsuranceView({super.key, required super.viewModel, this.onSelect, this.onChangePackage});

  @override
  Widget buildWidget(BuildContext context) {
    return buildFinalInsuranceView(context);
  }

  Widget buildFinalInsuranceView(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 0,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            viewModel.viewType == InsuranceViewType.planView
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: IntrinsicWidth(
                        child: GtdRadioTitle(
                            selectedIcon: Icon(
                              Icons.check_box_rounded,
                              color: AppColors.mainColor,
                            ),
                            unselectedIcon: Icon(
                              Icons.check_box_outline_blank_rounded,
                              color: AppColors.mainColor,
                            ),
                            label: viewModel.title,
                            labelStyle: const TextStyle(fontSize: 16),
                            value: true,
                            groupValue: viewModel.isSelected,
                            onChanged: (value) {
                              viewModel.toggle();
                              onSelect?.call(viewModel);
                            })),
                  )
                : const SizedBox(),
            viewModel.viewType == InsuranceViewType.finalView
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      viewModel.insuranceStatus,
                      style: TextStyle(fontSize: 15, color: viewModel.insuraceStatusColor),
                    ),
                  )
                : const SizedBox(),
            viewModel.viewType == InsuranceViewType.finalView
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(viewModel.title,
                        style: TextStyle(fontSize: 16, color: AppColors.boldText, fontWeight: FontWeight.w700)),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: GtdImage.svgFromSupplier(assetName: "/assets/icons/flight/insurance-baoviet.svg"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: GtdHtmlView(
                shrinkWrap: true,
                htmlString: viewModel.insuranceContent,
                onLinkTap: ({attributes, url}) async {
                  final Uri policyUrl = Uri.parse(url!);
                  if (!await launchUrl(policyUrl)) {
                    if (kDebugMode) {
                      print("cannot open url");
                    }
                  }
                },
              ),
            ),
            (viewModel.viewType == InsuranceViewType.planView && viewModel.insuranceType == GtdInsuranceType.flexi)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: CustomColors.borderColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<InsuranceClassItem>(
                            value: viewModel.selectedValue,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            dropdownColor: Colors.white,
                            elevation: 16,
                            style: TextStyle(color: AppColors.boldText, fontSize: 15, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Chọn gói bảo hiểm',
                              labelStyle:
                                  TextStyle(color: AppColors.subText, fontSize: 15, fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                            ),
                            onChanged: (InsuranceClassItem? value) {
                              viewModel.selectedValue = value;
                              viewModel.benefit = value?.benefit ?? "";

                              var parentViewModel = context.viewModelOf<FlightSSRSelectionPageViewModel>();
                              parentViewModel?.selectedFlexiItem = value;

                              GtdLoading.show();
                              BlocProvider.of<InsuranceCubit>(context)
                                  .getInsuracePlans(
                                      insurancePlanRq: parentViewModel!
                                          .createInsuranceRequest(planId: int.parse(value?.code ?? "1")))
                                  .whenComplete(() {
                                GtdLoading.hide();
                                // .whenComplete(() => BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget());
                              });
                              // BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                            },
                            items: viewModel.insuranceClassItems
                                .map<DropdownMenuItem<InsuranceClassItem>>((InsuranceClassItem value) {
                              return DropdownMenuItem<InsuranceClassItem>(
                                value: value,
                                child: Text(value.titleClass),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text.rich(TextSpan(
                  text: "Phí bảo hiểm: ",
                  style: TextStyle(fontSize: 13, color: AppColors.boldText, fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                        text: viewModel.amount,
                        style: TextStyle(fontSize: 13, color: AppColors.currencyText, fontWeight: FontWeight.w700))
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
