import 'package:dvt_helper/dvt_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_repository/app_repository/app_repository.dart';


part 'combo_draft_booking_state.dart';

class ComboDraftBookingCubit extends Cubit<ComboDraftBookingState> {
  ComboDraftBookingCubit() : super(ComboDraftBookingInitial());

  Future<Result<BookingDetailDTO, GtdApiError>> draftBookingCombo(GtdComboDraftBookingRq comboDraftBookingRq) async {
    var result = await GtdComboRepository.shared.draftBookingCombo(comboDraftBookingRq);
    return result;
  }
}
