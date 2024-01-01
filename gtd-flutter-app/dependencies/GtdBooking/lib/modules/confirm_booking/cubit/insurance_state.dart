part of 'insurance_cubit.dart';

sealed class InsuranceState extends Equatable {
  const InsuranceState();

  @override
  List<Object> get props => [];
}

final class InsuranceInitial extends InsuranceState {}

final class InsuranceLoading extends InsuranceState {}

final class InsuranceDetailLoaded extends InsuranceState {
  final List<GtdInsuranceDetail> insuraceDetails;

  const InsuranceDetailLoaded(this.insuraceDetails);
  @override
  List<Object> get props => [insuraceDetails];
}

final class InsurancePlanLoaded extends InsuranceState {
  final List<InsurancePlan> insurancePlans;

  const InsurancePlanLoaded(this.insurancePlans);
  @override
  List<Object> get props => [insurancePlans];
}

final class InsuranceError extends InsuranceState {}
