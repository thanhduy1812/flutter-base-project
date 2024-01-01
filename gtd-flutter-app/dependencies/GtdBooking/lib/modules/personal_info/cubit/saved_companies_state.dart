part of 'saved_companies_cubit.dart';

sealed class SavedCompaniesState extends Equatable {
  const SavedCompaniesState();

  @override
  List<Object> get props => [];
}

final class SavedCompaniesLoading extends SavedCompaniesState {

  @override
  List<Object> get props => [UniqueKey()];
}

final class SavedCompaniesInitial extends SavedCompaniesState {
  final List<GtdSavedCompanyRs> savedCompanies;
  const SavedCompaniesInitial({this.savedCompanies = const []});

  @override
  List<Object> get props => [savedCompanies];
}
