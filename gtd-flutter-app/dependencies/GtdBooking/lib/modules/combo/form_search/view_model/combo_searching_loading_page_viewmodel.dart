import 'package:gtd_booking/modules/combo/search_result/view_model/combo_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/hotel/form_search/model/search_hotel_form_model.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class ComboSearchingLoadingPageViewModel extends BasePageViewModel {
  SearchHotelFormModel searchHotelFormModel;
  final SearchFlightFormModel searchFlightFormModel;
  late final ComboSearchResultPageViewModel comboSearchResultPageViewModel;
  ComboSearchingLoadingPageViewModel({required this.searchHotelFormModel, required this.searchFlightFormModel}) {
    extendBodyBehindAppBar = true;
    comboSearchResultPageViewModel = ComboSearchResultPageViewModel.fromGtdComboSearchResultDTO(
        searchHotelFormModel: searchHotelFormModel, searchFlightFormModel: searchFlightFormModel);
  }

  int get adult => searchHotelFormModel.totalAdult;
  int get child => searchHotelFormModel.totalChild;
  int get infant => searchHotelFormModel.totalInfant;
  int get roomCount => searchHotelFormModel.rooms.length;
  String get originLocationTitle =>
      "${searchFlightFormModel.fromLocation.name!} (${searchFlightFormModel.fromLocation.code!})";
  String get destinationLocationTitle =>
      "${searchFlightFormModel.toLocation.name!} (${searchFlightFormModel.toLocation.code!})";
  String get fromDate => searchHotelFormModel.fromDate!.localDate("EEEE dd/MM/yyyy");
  String get toDate => searchHotelFormModel.toDate!.localDate("EEEE dd/MM/yyyy");

  Future<void> cachedSearchInfo() async {
    CacheHelper.shared
        .saveSharedObject(searchHotelFormModel.toCachedObjectMap(), key: CacheStorageType.comboHotelBox.name);
    CacheHelper.shared
        .saveSharedObject(searchFlightFormModel.toCachedObject(), key: CacheStorageType.comboFlightBox.name);
  }
}
