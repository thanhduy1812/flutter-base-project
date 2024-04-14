import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'flight_filter_options_state.dart';

class FlightFilterOptionsCubit extends Cubit<FlightFilterOptionsState> {
  BehaviorSubject<List<AllFilterOptionsDTO>> filterSubject = BehaviorSubject();
  Stream<List<AllFilterOptionsDTO>> get filterStream => filterSubject.stream;

  FlightFilterOptionsCubit() : super(FlightFilterOptionsInitial(allFilterOptionsDTO: const []));

  void initWithFilterOptions(List<AllFilterOptionsDTO> filterOptions) {
    List<AllFilterOptionsDTO> newFilterOptions = filterOptions.map((e) => e.copyWith()).toList();
    filterSubject.add(newFilterOptions);
    // emit(FlightFilterOptionsInitial(allFilterOptionsDTO: filterOptions));
  }

  Future<void> getFilterOptions(FilterAvailabilityRq filterAvailabilityRq) async {
    final resultSearch = await GtdFlightRepository.shared.getAllFilterOptions(filterAvailabilityRq);
    resultSearch.whenSuccess((success) {
      // emit(state.copyWith(allFilterOptionsDTO: success));
      filterSubject.add(success);
      Logger.i(success.toString());
    });
  }

  void selectFilterItem(FilterOption? filterOption) {
    if (filterOption != null) {
      List<AllFilterOptionsDTO> currentFilterOptions = filterSubject.value;
      currentFilterOptions
          .map((e) => e.filterOptions)
          .whereType<List<FilterOption>>()
          .expand((element) => element)
          .whereType<FilterOption>()
          .map((e) {
        if (e == filterOption) {
          e.isSelected = !filterOption.isSelected;
        }
      }).toList();
      filterSubject.add(currentFilterOptions);
    }
  }

  @override
  Future<void> close() {
    filterSubject.close();
    return super.close();
  }

  void applyFilter(List<AllFilterOptionsDTO> filterOptions) {
    filterSubject.add(filterOptions);
  }
}
