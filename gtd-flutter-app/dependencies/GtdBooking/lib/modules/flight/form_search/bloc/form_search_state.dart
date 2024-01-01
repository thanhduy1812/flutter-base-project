part of 'form_search_bloc.dart';

enum FormSearchValid { valid, inValid }

class FormSearchState {
  const FormSearchState({
    this.valid = FormSearchValid.inValid,
    this.formSearchModel,
  });

  final FormSearchValid valid;
  final SearchFlightInfo? formSearchModel;

  FormSearchState copyWith({
    FormSearchValid? valid,
    SearchFlightInfo? formSearchModel,
  }) {
    return FormSearchState(
      valid: valid ?? this.valid,
      formSearchModel: formSearchModel ?? this.formSearchModel,
    );
  }

  @override
  String toString() {
    return '''PostState { valid: $valid, formSearchModel: $formSearchModel }''';
  }
}
