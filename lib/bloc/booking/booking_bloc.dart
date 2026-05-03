import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../repositories/booking_repository.dart';
import '../../models/request/booking_request.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        final request = BookingRequest(
          ticketPackageId: event.packageId,
          quantity: event.quantity,
          totalPrice: event.price,
        );
        final snapToken = await repository.getSnapToken(request, event.token);
        if (snapToken != null) {
          emit(BookingWaitingPayment(snapToken));
        } else {
          emit(BookingFailure("Gagal mendapatkan token pembayaran"));
        }
      } catch (e) {
        emit(BookingFailure(e.toString()));
      }
    });

    on<FetchUserBookings>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookings = await repository.getMyBookings(event.token);
        emit(BookingLoaded(bookings));
      } catch (e) {
        emit(BookingFailure(e.toString()));
      }
    });
  }
}