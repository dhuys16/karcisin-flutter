import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toFullEventDate() {
    return DateFormat('EEEE, dd MMMM yyyy | HH:mm').format(this);
  }
}