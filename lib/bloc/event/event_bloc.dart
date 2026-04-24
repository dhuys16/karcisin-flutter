import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(EventInitial()) {

    on<FetchEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final events = await eventRepository.getEvents();
        emit(EventLoaded(events));
      } catch (e) {
        print("DEBUG EVENT ERROR: $e");
        emit(EventError("Gagal mengambil data dari server: $e"));
      }
    });
  }
}
