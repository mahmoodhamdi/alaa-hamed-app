import 'package:intl/intl.dart';

class TFormatter {
  static String formatDate(String dateString) {
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('MMM d, y').format(parsedDate);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

}
