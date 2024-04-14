import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'base_delegate_state.dart';

class BaseDelegateCubit extends Cubit<BaseDelegateState> {
  BaseDelegateCubit() : super(BaseDelegateInitial());
}
