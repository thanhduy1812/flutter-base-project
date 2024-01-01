import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/network/models/wrapped_result/result.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/combo_resource/models/request/gtd_combo_draft_booking_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_combo_repository/gtd_combo_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

part 'combo_draft_booking_state.dart';

class ComboDraftBookingCubit extends Cubit<ComboDraftBookingState> {
  ComboDraftBookingCubit() : super(ComboDraftBookingInitial());

  Future<Result<BookingDetailDTO, GtdApiError>> draftBookingCombo(GtdComboDraftBookingRq comboDraftBookingRq) async {
    var result = await GtdComboRepository.shared.draftBookingCombo(comboDraftBookingRq);
    return result;
  }
}
