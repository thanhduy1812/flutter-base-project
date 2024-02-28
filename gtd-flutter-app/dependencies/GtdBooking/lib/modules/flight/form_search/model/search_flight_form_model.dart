// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/utils/cubit/gtd_text_field_validation_cubit.dart';

import 'destination.dart';

enum SearchInfoFlightGroupType { location, dateTime, passengers, all }

class SearchFlightFormModel {
  Destination fromLocation;
  Destination toLocation;
  bool isRoundTrip = false;
  DateTime? departDate;
  DateTime? returnDate;
  int adult = 1;
  int child = 0;
  int infant = 0;
  SearchFlightFormModel({
    required this.fromLocation,
    required this.toLocation,
    required this.isRoundTrip,
    this.departDate,
    this.returnDate,
    this.adult = 1,
    this.child = 0,
    this.infant = 0,
  });

  Map<String, dynamic> toCachedObject() {
    return <String, dynamic>{
      'fromLocation': fromLocation.toMap(),
      'toLocation': toLocation.toMap(),
      'isRoundTrip': isRoundTrip,
      'departDate': departDate?.millisecondsSinceEpoch,
      'returnDate': returnDate?.millisecondsSinceEpoch,
      'adult': adult,
      'child': child,
      'infant': infant,
    };
  }

  factory SearchFlightFormModel.fromCachedObject(Map<String, dynamic> map) {
    return SearchFlightFormModel(
      fromLocation: Destination.fromMap(map['fromLocation'] as Map<String, dynamic>),
      toLocation: Destination.fromMap(map['toLocation'] as Map<String, dynamic>),
      isRoundTrip: map['isRoundTrip'] as bool,
      departDate: map['departDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['departDate'] as int) : null,
      returnDate: map['returnDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['returnDate'] as int) : null,
      adult: map['adult'] as int,
      child: map['child'] as int,
      infant: map['infant'] as int,
    );
  }

  String passengerCountSubtitle() {
    String subTitle = '$adult Người lớn';
    if (child > 0) {
      subTitle = '$subTitle, $child trẻ em';
    }
    if (infant > 0) {
      subTitle = '$subTitle, $infant em bé';
    }
    return subTitle;
  }
}

class SearchInfoLocationVM extends GtdValidateFieldVM {
  Destination _destination;

  Destination get destination => _destination;

  set destination(Destination value) {
    _destination = value;
    text = value.name ?? "";
    // onChangeValue(value.name ?? "");
  }

  SearchInfoLocationVM({
    required Destination destination,
    super.label,
    super.allowEmpty,
    super.type = GtdTextFieldType.selection,
    super.inputUserBehavior = GtdInputUserBehavior.selection,
    super.inputValidateBehavior = GtdInputValidateBehavior.auto,
    super.hasUnderlineBorder,
  }) : _destination = destination {
    super.label = label;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_destination': _destination.toMap(),
    };
  }

  factory SearchInfoLocationVM.fromMap(Map<String, dynamic> map) {
    return SearchInfoLocationVM(
      destination: Destination.fromMap(map['_destination'] as Map<String, dynamic>),
    );
  }
}

class SearchInfoPassengerVM implements EquatableMixin {
  late int value;
  late int min;
  late int max;
  SearchInfoPassengerVM({
    int? value,
    int? min,
    int? max,
  }) {
    this.value = value ?? 0;
    this.min = min ?? 0;
    this.max = max ?? 9;
  }

  @override
  List<Object?> get props => [value, min, max];

  @override
  bool? get stringify => false;

  @override
  String toString() => 'SearchInfoPassenger(value: $value, min: $min, max: $max)';
}
