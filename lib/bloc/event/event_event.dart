abstract class EventEvent {}

class FetchEvents extends EventEvent {

}

class SearchEvent extends EventEvent {
  final String query;
  SearchEvent(this.query);
}
