import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/payment/view_model/vib_invoice_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/gtd_booking_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:rxdart/rxdart.dart';

part 'booking_result_state.dart';

class BookingResultCubit extends Cubit<BookingResultState> {
  BookingResultCubit() : super(BookingDetailLoadingState(status: BookingDetailStatus.isLoading));

  BehaviorSubject<BookingDetailDTO> bookingDetailSubject = BehaviorSubject<BookingDetailDTO>();
  BehaviorSubject<List<VibInvoiceModel>> bookingDetailInvoiceSubject = BehaviorSubject<List<VibInvoiceModel>>();

  void currentState(String bookingNumber) async {
    emit(BookingDetailLoadingState(status: BookingDetailStatus.isLoading));
    //Sink initValue to Stream
    final resultSearch = await GtdBookingRepository.shared.getBookingDetailByBookingNumber(bookingNumber);
    resultSearch.when((success) {
      bookingDetailSubject = BehaviorSubject.seeded(success);
      emit(BookingDetailLoadingState(status: BookingDetailStatus.success));
    }, (error) {
      bookingDetailSubject.addError(error);
      emit(BookingDetailErrorState(apiError: error));
    });
  }

  void finalBookingDetail(String bookingNumber) async {
    emit(BookingDetailLoadingState(status: BookingDetailStatus.isLoading));
    //Sink initValue to Stream
    final resultSearch = await GtdBookingRepository.shared.getFinalBookingDetailByBookingNumber(bookingNumber);
    resultSearch.when((success) {
      bookingDetailSubject = BehaviorSubject.seeded(success);
      emit(BookingDetailLoadingState(status: BookingDetailStatus.success));
    }, (error) {
      emit(BookingDetailErrorState(apiError: error));
    });
  }

  @override
  Future<void> close() {
    bookingDetailSubject.close();
    bookingDetailInvoiceSubject.close();
    return super.close();
  }
}
