class SimpleDateHelper {
  /// Formats a [DateTime] into a simple human-readable string
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? "Last week" : "$weeks weeks ago";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? "Last month" : "$months months ago";
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? "Last year" : "$years years ago";
    }
  }
}
