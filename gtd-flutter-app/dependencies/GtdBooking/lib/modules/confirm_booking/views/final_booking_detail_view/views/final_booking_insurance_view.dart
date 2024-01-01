import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/insurance_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/insurance_view/view/insurance_view.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/insurance_view/view_model/insurance_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';

import '../view_model/final_booking_insurance_viewmodel.dart';

class FinalBookingInsuranceView extends BaseView<FinalBookingInsuranceViewModel> {
  const FinalBookingInsuranceView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => InsuranceCubit(),
      child: BlocBuilder<InsuranceCubit, InsuranceState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: InsuranceView(
                    viewModel: InsuranceViewModel.fromInsuranceDetail(insuranceDetail: viewModel.insuranceDetail)),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: Text("Khách hưởng bảo hiểm",
                        style: TextStyle(fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var insuraceInfo = viewModel.insuranceDetail.insuredInfos![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: GtdInfoRow(
                                  leftText: insuraceInfo.gender ?? "Nam", rightText: insuraceInfo.name ?? ""),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: (viewModel.insuranceDetail.insuredInfos ?? []).length),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
