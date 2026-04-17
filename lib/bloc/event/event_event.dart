abstract class EventEvent {}

class FetchEvents extends EventEvent {
  // Event untuk mengambil data dari repository/API
}

class SearchEvent extends EventEvent {
  final String query;
  SearchEvent(this.query);
}