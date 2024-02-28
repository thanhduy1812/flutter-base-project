import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/extension/search_booking_rs_extension.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/request/search_booking_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/response/search_booking_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/gtd_booking_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:rxdart/rxdart.dart';

part 'my_booking_state.dart';

class MyBookingCubit extends Cubit<MyBookingState> {
  MyBookingCubit() : super(MyBookingLoadingState(status: MyBookingStatus.isLoading));

  BehaviorSubject<SearchBookingRs> myBookingSubject = BehaviorSubject<SearchBookingRs>();

  BehaviorSubject<SearchBookingRq> myBookingFilterSubject = BehaviorSubject<SearchBookingRq>();

  StreamController<String> querySearchController = StreamController();

  // StreamSubscription<dynamic>? _cancelableSub;

  void initSearchMyBooking() async {
    SearchBookingRq searchBookingRq = SearchBookingRq.initSearchBookingRq();
    myBookingFilterSubject = BehaviorSubject.seeded(searchBookingRq);
    await searchMyBooking(searchBookingRq);
  }

  Future<void> searchMyBooking(SearchBookingRq searchBookingRq) async {
    SearchBookingRs searchBookingRs = SearchBookingRs();
    emit(MyBookingLoadingState(status: MyBookingStatus.isLoading));
    final resultSearch = await GtdBookingRepository.shared.searchListMyBooking(searchBookingRq);
    resultSearch.when((success) {
      searchBookingRs.updateListItemMyBooking(success);
      myBookingSubject = BehaviorSubject.seeded(searchBookingRs);
      emit(MyBookingLoadingState(status: MyBookingStatus.success));
    }, (error) => emit(MyBookingErrorState(apiError: error)));
  }

  void initController() {
    querySearchController.stream.debounceTime(const Duration(milliseconds: 300)).listen((event) {
      filterMyBooking(bookingNumber: event);
    });
  }

  Future<void> filterMyBooking({
    String? bookingNumber,
    SupplierType? supplierType,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    SearchBookingRq searchBookingRq = SearchBookingRq.initSearchBookingRq();
    searchBookingRq.bookingNumber = bookingNumber;
    searchBookingRq.supplierType = supplierType?.value ?? "";
    searchBookingRq.fromDate = fromDate?.localDate("dd/MMM/yyyy");
    searchBookingRq.toDate = fromDate?.localDate("dd/MMM/yyyy");
    return searchMyBooking(searchBookingRq);
  }

  void loadMoreMyBooking() async {
    SearchBookingRs searchBookingRs = myBookingSubject.value;
    if (searchBookingRs.last == false) {
      emit(MyBookingLoadingState(status: MyBookingStatus.isLoadMore));
      final filterMyBooking = myBookingFilterSubject.value;
      filterMyBooking.page = searchBookingRs.number! + 1;
      final resultSearch = await GtdBookingRepository.shared.searchMyBooking(filterMyBooking);
      resultSearch.whenSuccess((success) {
        searchBookingRs.updateListItemMyBooking(success);
        myBookingSubject.add(searchBookingRs);
        myBookingFilterSubject.add(filterMyBooking);
        emit(MyBookingLoadingState(status: MyBookingStatus.success));
      });
    } else {
      emit(MyBookingLoadingState(status: MyBookingStatus.success));
    }
  }

  void filterListMyBooking(SearchBookingRq searchBookingRq) {
    myBookingFilterSubject = BehaviorSubject.seeded(searchBookingRq);
  }

  void refreshMyBooking() async {
    SearchBookingRs searchBookingRs = SearchBookingRs();
    emit(MyBookingLoadingState(status: MyBookingStatus.isLoading));
    final filterMyBooking = myBookingFilterSubject.value;
    filterMyBooking.page = 0;
    final resultSearch = await GtdBookingRepository.shared.searchMyBooking(filterMyBooking);
    resultSearch.whenSuccess((success) {
      searchBookingRs.updateListItemMyBooking(success);
      myBookingSubject.add(success);
      myBookingFilterSubject = BehaviorSubject.seeded(filterMyBooking);
      emit(MyBookingLoadingState(status: MyBookingStatus.success));
    });
  }

  @override
  Future<void> close() {
    myBookingSubject.close();
    myBookingFilterSubject.close();
    querySearchController.close();
    return super.close();
  }
}
