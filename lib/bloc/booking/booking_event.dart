abstract class BookingEvent {}

class CreateBooking extends BookingEvent {
  final int packageId;
  final int quantity;// Digunakan untuk menampung total harga
  final String token;

  CreateBooking({
    required this.packageId,
    required this.quantity,
    required this.token,
  });
}

class FetchUserBookings extends BookingEvent {
  final String token;
  FetchUserBookings(this.token);
}