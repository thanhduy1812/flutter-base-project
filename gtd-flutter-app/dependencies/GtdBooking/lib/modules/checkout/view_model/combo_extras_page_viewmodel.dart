

import 'package:gtd_repository/gtd_repository.dart';

import 'flight_extras_page_viewmodel.dart';

class ComboExtrasPageViewModel extends FlightExtrasPageViewModel {
  ComboExtrasPageViewModel({super.bookingDetailDTO, required super.initialSsrItems}) {
    bookingNumber = bookingDetailDTO!.bookingNumber!;
  }

  @override
  
  List<ServiceType> get serviceTypes => [ServiceType.baggare, ServiceType.meal, ServiceType.insurance, ServiceType.hotelAdditional];

}