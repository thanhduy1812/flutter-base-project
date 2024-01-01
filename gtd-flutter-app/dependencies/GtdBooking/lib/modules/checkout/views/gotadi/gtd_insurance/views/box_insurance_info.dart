import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/insurance_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/view_model/final_booking_insurance_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/final_booking_insurance_view.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../view_model/box_insurance_info_viewmodel.dart';

class BoxInsuranceInfo extends BaseView<BoxInsuranceInfoViewModel> {
  const BoxInsuranceInfo({super.key, required super.viewModel});
  @override
  Widget buildWidget(BuildContext context) {
    return InkWell(
      onTap: viewModel.insuranceDetail == null
          ? null
          : () {
              GtdPresentViewHelper.presentView(
                  title: "Bảo hiểm",
                  context: context,
                  hasInsetBottom: false,
                  useRootContext: true,
                  contentColor: Colors.grey.shade100,
                  builder: Builder(
                    builder: (context) {
                      return FinalBookingInsuranceView(
                          viewModel: FinalBookingInsuranceViewModel(viewModel.insuranceDetail!));
                    },
                  ));
            },
      child: SizedBox(
        width: 300,
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        viewModel.title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.mainColor,
                      )
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdInfoRow(leftText: "Số khách được hưởng", rightText: viewModel.numberInsured),
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdInfoRow(
                      leftText: viewModel.showStatus ? "Trạng thái" : "Phí bảo hiểm",
                      rightText: viewModel.showStatus ? viewModel.insuranceStatus : viewModel.insuranceFee,
                      rightColor: viewModel.showStatus ? viewModel.statusColor : Colors.grey.shade900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildListHorizontalInsuranceInfo(
      {required BuildContext context, required BookingDetailDTO bookingDetailDTO, bool showStatus = false, G}) {
    return BlocProvider(
      create: (context) => InsuranceCubit()..getInsuraceDetail(bookingNumber: bookingDetailDTO.bookingNumber!),
      child: BlocBuilder<InsuranceCubit, InsuranceState>(
        builder: (insuranceContext, state) {
          if (state is InsuranceLoading) {
            return buildListInsuranceLoading();
          } else if (state is InsuranceDetailLoaded) {
            var listInsurance = (state).insuraceDetails;
            if (listInsurance.isEmpty) {
              return const SizedBox();
            }
            return SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 16),
                itemCount: listInsurance.length,
                itemBuilder: (context, index) {
                  return BoxInsuranceInfo(
                    viewModel: BoxInsuranceInfoViewModel.fromBookingInfoTraveler(
                        insuranceDetail: listInsurance[index],
                        travellers: bookingDetailDTO.flightDetailItems?.firstOrNull?.travelersInfo ?? []),
                  );
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  static Widget buildListHorizontalInsuranceInfoConfirmPage(
      {required BuildContext context, required List<TravelerInputInfoDTO> inputInfoDTOs, bool showStatus = false, G}) {
    var listInsuranceVM = BoxInsuranceInfoViewModel.fromListTravelerInputDTO(inputInfoDTOs);
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemCount: listInsuranceVM.length,
        itemBuilder: (context, index) {
          return BoxInsuranceInfo(
            viewModel: listInsuranceVM[index],
          );
        },
      ),
    );
  }

  static Widget buildListInsuranceLoading() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade50,
            child: const SizedBox(
              width: 300,
              child: Card(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
