import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_all_rate_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/gtd_hotel_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

part 'hotel_search_detail_state.dart';

class HotelSearchDetailCubit extends Cubit<HotelSearchDetailState> {
  GtdHotelSearchAllRateRq? searchAllRateRq;
  HotelSearchDetailCubit() : super(HotelSearchDetailInitial());

  void searchHotelAllRate(GtdHotelSearchAllRateRq searchAllRateRq) async {
    this.searchAllRateRq = searchAllRateRq;
    emit(HotelSearchDetailLoading());
    var result = await GtdHotelRepository.shared.searchHotelAllRate(searchAllRateRq);
    result.when((success) {
      emit(HotelSearchDetailLoaded(success));
    }, (error) => emit(HotelSearchDetailError(error)));
  }
}
