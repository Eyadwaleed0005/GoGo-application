import 'package:intl/intl.dart';

class DriverHistoryMoedl {
  final int id;
  final int review;
  final String paymentWay;
  final String from;
  final String to;
  final DateTime date;
  final int totalTip;
  final int driverId;

  DriverHistoryMoedl({
    required this.id,
    required this.review,
    required this.paymentWay,
    required this.from,
    required this.to,
    required this.date,
    required this.totalTip,
    required this.driverId,
  });

  factory DriverHistoryMoedl.fromJson(Map<String, dynamic> json) {
    return DriverHistoryMoedl(
      id: json['id'] ?? 0,
      review: json['review'] ?? 0,
      paymentWay: json['paymentWay'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      totalTip: json['totalTip'] ?? 0,
      driverId: json['driverId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review': review,
      'paymentWay': paymentWay,
      'from': from,
      'to': to,
      'date': date.toIso8601String(),
      'totalTip': totalTip,
      'driverId': driverId,
    };
  }

  static List<DriverHistoryMoedl> fromJsonList(dynamic json) {
    if (json is Map && json.containsKey("\$values") && json["\$values"] is List) {
      return (json["\$values"] as List)
          .map((e) => DriverHistoryMoedl.fromJson(e))
          .toList();
    } else if (json is List) {
      return json.map((e) => DriverHistoryMoedl.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  String get formattedDate {
    return DateFormat("EEEE, dd/MM/yyyy").format(date);
  }

  String get formattedTime {
    return DateFormat("hh:mm a").format(date);
  }
  String get relativeDate {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    if (difference <= 7) return "Last week";
    return "Older";
  }
}
