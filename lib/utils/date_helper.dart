import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toFullEventDate() {
    return DateFormat('EEEE, dd MMMM yyyy | HH:mm').format(this);
  }

  String toShortDate() {
    return DateFormat('MMM dd • HH:mm').format(this).toUpperCase();
  }

  String toTimeOnly() {
    return DateFormat('HH:mm').format(this);
  }

  String toEventCardDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }
}
