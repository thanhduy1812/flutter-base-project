import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_repository/gtd_repository.dart';

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
