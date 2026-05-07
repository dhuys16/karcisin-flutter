import '../../models/response/booking_response.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingWaitingPayment extends BookingState {
  final String snapToken;
  BookingWaitingPayment(this.snapToken);
}
class BookingLoaded extends BookingState {
  final List<BookingData> bookings;
  BookingLoaded(this.bookings);
}
class BookingFailure extends BookingState {
  final String message;
  BookingFailure(this.message);
}