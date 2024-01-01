import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/search_hotel_page_viewmodel.dart';

part 'hotel_search_form_state.dart';

class HotelSearchFormCubit extends Cubit<HotelSearchFormState> {
  SearchHotelPageViewModel viewModel;
  HotelSearchFormCubit({required this.viewModel}) : super(HotelSearchFormInitial());
}
