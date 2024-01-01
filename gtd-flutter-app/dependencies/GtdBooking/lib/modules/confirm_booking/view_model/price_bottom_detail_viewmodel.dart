// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/reponse/gtd_hotel_search_all_rates_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';
import '../../checkout/view_model/gtd_display_price_item_vm.dart';

class PriceBottomDetailViewModel extends BaseViewModel {
  List<GtdDisplayPriceItemVM> items = [];
  BookingDetailDTO? bookingDetailDTO;
  GtdDisplayPriceItemVM? headerVM;
  GtdDisplayPriceItemVM totalPriceVM = GtdDisplayPriceItemVM();
  PriceBottomDetailViewModel({
    this.items = const [],
  });

  factory PriceBottomDetailViewModel.fromBookingDetailDTO(BookingDetailDTO bookingDetailDTO) {
    PriceBottomDetailViewModel viewModel = PriceBottomDetailViewModel()
      ..headerVM = GtdDisplayPriceItemVM.fromProductType(bookingDetailDTO: bookingDetailDTO)
      ..totalPriceVM = GtdDisplayPriceItemVM.totalPrice(bookingDetailDTO)
      ..items = GtdDisplayPriceItemVM.fromBookingDetailDTO(bookingDetailDTO);
    return viewModel;
  }

  factory PriceBottomDetailViewModel.fromRatePlan(RatePlan ratePlan) {
    GtdDisplayPriceItemVM basePriceVM = GtdDisplayPriceItemVM(
        type: GtdDisplayItemType.hotel,
        price: ratePlan.basePrice?.toDouble() ?? 0,
        shortTitle: ratePlan.tempBasePriceInfo);
    GtdDisplayPriceItemVM taxFeePriceVM = GtdDisplayPriceItemVM(
        type: GtdDisplayItemType.taxFee, price: ratePlan.taxAndFees?.toDouble() ?? 0, shortTitle: "Thuế & phí");
    PriceBottomDetailViewModel viewModel = PriceBottomDetailViewModel()
      ..totalPriceVM = GtdDisplayPriceItemVM(
          type: GtdDisplayItemType.totalPrice,
          price: ratePlan.totalPrice?.toDouble() ?? 0,
          shortTitle: "Tổng tạm tính",
          subTitle: "Đã bao gồm Thuế & phí")
      ..items = [basePriceVM, taxFeePriceVM];
    return viewModel;
  }

  factory PriceBottomDetailViewModel.fromRatePlanCombineFlights(
      RatePlan ratePlan, List<GtdFlightItemDetail> flighItemDetails) {
    double flightTaxFees = flighItemDetails
        .map((e) => e.flightItem)
        .map((e) => e.selectedCabinOption)
        .map((e) => e?.priceInfo?.taxFee ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    double flightBaseFare = flighItemDetails
        .map((e) => e.flightItem)
        .map((e) => e.selectedCabinOption)
        .map((e) => e?.priceInfo?.basePrice ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    int numberNights = ((ratePlan.paxPrice?.firstOrNull?.nightPrices ?? []).length);
    // int totalRoom = ratePlan.paxPrice?.length ?? 0;
    int totalGuest = ratePlan.paxPrice?.firstOrNull?.paxInfo?.totalGuest ?? 0;
    String basePriceSubTitle = "Trọn gói/ $totalGuest khách/ $numberNights đêm";
    GtdDisplayPriceItemVM basePriceVM = GtdDisplayPriceItemVM(
        type: GtdDisplayItemType.combo,
        price: flightBaseFare + (ratePlan.basePrice?.toDouble() ?? 0),
        shortTitle: basePriceSubTitle);
    GtdDisplayPriceItemVM taxFeePriceVM = GtdDisplayPriceItemVM(
        type: GtdDisplayItemType.taxFee,
        price: flightTaxFees + (ratePlan.taxAndFees?.toDouble() ?? 0),
        shortTitle: "Thuế & phí");
    PriceBottomDetailViewModel viewModel = PriceBottomDetailViewModel()
      ..totalPriceVM = GtdDisplayPriceItemVM(
          type: GtdDisplayItemType.totalPrice,
          price: flightBaseFare + flightTaxFees + (ratePlan.totalPrice?.toDouble() ?? 0),
          shortTitle: "Tổng tạm tính",
          subTitle: "Đã bao gồm Thuế & phí")
      ..items = [basePriceVM, taxFeePriceVM];
    return viewModel;
  }
}
