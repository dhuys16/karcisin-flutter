import '../../models/response/booking_response.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingWaitingPayment extends BookingState {
  final String snapToken;
  BookingWaitingPayment(this.snapToken);
}
class BookingLoaded extends BookingState {
  final List<Booking> bookings;
  BookingLoaded(this.bookings);
}
class BookingFailure extends BookingState {
  final String message;
  BookingFailure(this.message);
}