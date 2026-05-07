import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karcisin_app/main.dart';
import 'package:karcisin_app/models/response/booking_response.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../repositories/booking_repository.dart';
import '../../models/request/booking_request.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());

      // 1. Cek apakah variabel global sudah terisi
      if (midtransGlobal == null) {
        emit(BookingFailure("Sabar Ri, Midtrans-nya lagi loading. Coba sedetik lagi!"));
        return;
      }

      try {
        final result = await repository.createBooking(event.token, event.packageId, event.quantity);

        if (result.snapToken != null) {
          // 2. Gunakan variabel global tadi
          midtransGlobal!.setTransactionFinishedCallback((result) {
            if (result.status == 'settlement') {
              add(FetchUserBookings(event.token));
            }
          });

          midtransGlobal!.startPaymentUiFlow(token: result.snapToken!);
          emit(BookingWaitingPayment(result.snapToken!));
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
