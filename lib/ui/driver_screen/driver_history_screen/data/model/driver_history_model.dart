import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DriverHistoryModel {
  final int id;
  final int review;
  final String paymentWay;
  final String from;
  final String to;
  final DateTime date;
  final double totalTip;
  final int driverId;

  DriverHistoryModel({
    required this.id,
    required this.review,
    required this.paymentWay,
    required this.from,
    required this.to,
    required this.date,
    required this.totalTip,
    required this.driverId,
  });

  factory DriverHistoryModel.fromJson(Map<String, dynamic> json) {
    return DriverHistoryModel(
      id: json['id'] ?? 0,
      review: json['review'] ?? 0,
      paymentWay: json['paymentWay'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      totalTip: (json['totalTip'] as num?)?.toDouble() ?? 0.0,
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

  static List<DriverHistoryModel> fromJsonList(dynamic json) {
    if (json is Map && json.containsKey("\$values") && json["\$values"] is List) {
      return (json["\$values"] as List)
          .map((e) => DriverHistoryModel.fromJson(e))
          .toList();
    } else if (json is List) {
      return json.map((e) => DriverHistoryModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  String formattedDate(BuildContext context) {
    final locale = context.locale.languageCode;

    if (locale == "ar") {
      return DateFormat('dd MMMM yyyy', 'ar').format(date);
    } else {
      return DateFormat('MMM dd, yyyy', locale).format(date);
    }
  }

  String formattedTime(BuildContext context) {
    final locale = context.locale.languageCode;

    if (locale == "ar") {
      return DateFormat('h:mm a', 'ar')
          .format(date)
          .replaceAll("AM", "ص")
          .replaceAll("PM", "م");
    } else {
      return DateFormat('h:mm a', locale).format(date);
    }
  }


}
