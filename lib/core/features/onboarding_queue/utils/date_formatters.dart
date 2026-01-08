import 'package:intl/intl.dart';

class DateFormatters {
  DateFormatters._(); // Private constructor to prevent instantiation

  /// Formats a date string to MM/dd/yyyy format
  /// Returns 'MM/DD/YYYY' if the date string is null or empty
  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'MM/DD/YYYY';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MM/dd/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// Formats a date string to "MMMM d, yyyy 'at' h:mm a" format
  /// Example: "January 15, 2024 at 3:30 PM"
  /// Returns 'N/A' if the date string is null or empty
  static String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy \'at\' h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// Formats a date string to dd/MM/yyyy format (for table display)
  /// Returns '---' if the date string is null or empty
  static String formatDateForTable(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '---';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
