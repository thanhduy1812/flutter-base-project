part of 'country_codes_cubit.dart';

abstract class CountryCodesState extends Equatable {
  final List<GtdCountryCodeRs> countries;
  const CountryCodesState({this.countries = const []});

  @override
  List<Object> get props => [countries];
}

class CountryCodesInitial extends CountryCodesState {
  const CountryCodesInitial({super.countries});
}
