import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(EventInitial()) {
    // Menangani aksi FetchEvents
    on<FetchEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final events = await eventRepository.getEvents();
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError("Gagal mengambil data event: ${e.toString()}"));
      }
    });
  }
}