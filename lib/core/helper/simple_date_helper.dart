import 'package:easy_localization/easy_localization.dart';

class SimpleDateHelper {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return "today".tr();
    } else if (difference.inDays == 1) {
      return "yesterday".tr();
    } else if (difference.inDays < 7) {
      return tr("days_ago", args: ["${difference.inDays}"]);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? "last_week".tr() : tr("weeks_ago", args: ["$weeks"]);
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? "last_month".tr() : tr("months_ago", args: ["$months"]);
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? "last_year".tr() : tr("years_ago", args: ["$years"]);
    }
  }
}
