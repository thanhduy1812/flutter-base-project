part of 'add_booking_traveler_cubit.dart';

abstract class AddBookingTravelerState extends Equatable {
  const AddBookingTravelerState();

  @override
  List<Object> get props => [];
}

class AddBookingTravelerInitial extends AddBookingTravelerState {}

class AddBookingTravelerLoading extends AddBookingTravelerState {}

class AddBookingTravelerLoaded extends AddBookingTravelerState {}

class AddBookingTravelerOtp extends AddBookingTravelerState {}

class AddBookingTravelerError extends AddBookingTravelerState {}
