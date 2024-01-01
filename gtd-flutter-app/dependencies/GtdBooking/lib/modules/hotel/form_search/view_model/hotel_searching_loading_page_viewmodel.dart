// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';

import 'package:gtd_booking/modules/hotel/form_search/model/search_hotel_form_model.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class HotelSearchingLoadingPageViewModel extends BasePageViewModel {
  SearchHotelFormModel searchHotelFormModel;
  HotelSearchingLoadingPageViewModel({
    required this.searchHotelFormModel,
  }) {
    extendBodyBehindAppBar = true;
  }

  int get adult => searchHotelFormModel.totalAdult;
  int get child => searchHotelFormModel.totalChild;
  int get roomCount => searchHotelFormModel.rooms.length;
  String get locationTitle => searchHotelFormModel.locationDTO.name;
  String get fromDate => searchHotelFormModel.fromDate!.localDate("EEEE dd/MM/yyyy");
  String get toDate => searchHotelFormModel.toDate!.localDate("EEEE dd/MM/yyyy");
}
