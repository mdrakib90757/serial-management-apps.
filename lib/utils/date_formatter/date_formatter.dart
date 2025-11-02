import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM, yyyy').format(date);
  }

  // today dateTime
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM, yyyy').format(date);
  }

  static String formatApiTimeToDisplayTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "N/A";
    }
    try {
      final utcTime = DateTime.parse(dateString);
      final localTime = utcTime.toLocal();
      return DateFormat('hh:mm a').format(localTime);
    } catch (e) {
      print("Date format error: $e");
      return "Time Error";
    }
  }

  static String formatForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime? _parseToLocal(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      if (dateString.endsWith('Z')) {
        return DateTime.parse(dateString).toLocal();
      } else {
        return DateTime.parse('${dateString}Z').toLocal();
      }
    } catch (e) {
      print("DateFormatter parse error: $e for date '$dateString'");
      return null;
    }
  }

  static String formatForStatusTime(String? dateString) {
    final localTime = _parseToLocal(dateString);
    if (localTime == null) return "N/A";

    return DateFormat('E hh:mm:ss a').format(localTime);
  }

  static String formatForStatus(DateTime? dateTime) {
    if (dateTime == null) {
      return "N/A";
    }
    try {
      return DateFormat('hh:mm:ss a,').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  static String formatForApproxTime(String? dateString) {
    final localTime = _parseToLocal(dateString);
    if (localTime == null) return "N/A";

    return DateFormat('E hh:mm a').format(localTime);
  }

  static String formatForDisplayTimeOnly(String? dateString) {
    final localTime = _parseToLocal(dateString);
    if (localTime == null) return "N/A";
    return DateFormat('hh:mm a').format(localTime);
  }
}
