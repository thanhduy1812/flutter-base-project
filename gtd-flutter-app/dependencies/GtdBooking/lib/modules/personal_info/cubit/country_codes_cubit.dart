import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';

part 'country_codes_state.dart';

class CountryCodesCubit extends Cubit<CountryCodesState> {
  CountryCodesCubit({List<GtdCountryCodeRs>? countries}) : super(const CountryCodesInitial()) {
    bool isLogin = true;
    if (isLogin && countries == null) {
      getCountries();
    } else {
      emit(CountryCodesInitial(countries: countries));
    }
  }

  Future<void> getCountries() async {
    var result = await GtdFlightRepository.shared.getCountries();
    result.when((success) {
      emit(CountryCodesInitial(countries: success));
    }, (error) {
      Logger.e(error.message);
      emit(const CountryCodesInitial(countries: []));
    });
  }
}
