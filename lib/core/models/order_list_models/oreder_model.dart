import 'package:intl/intl.dart';

class GetAllOrdersModel {
  final int id;
  final String userId;
  final String userPhone;
  final DateTime date; // الوقت كما هو على الجهاز
  final String from;
  final String to;
  final LatLngModel fromLatLng;
  final LatLngModel toLatLng;
  final double expectedPrice;
  final String type;
  final double distance;
  final String notes;
  final int noPassengers;
  final String userName;
  final String userImage;
  final String? status;     
  final int? driverId;      
  final int? review;        
  final String paymentWay;  // 🔥 بقت non-nullable ومعاها default value

  GetAllOrdersModel({
    required this.id,
    required this.userId,
    required this.userPhone,
    required this.date,
    required this.from,
    required this.to,
    required this.fromLatLng,
    required this.toLatLng,
    required this.expectedPrice,
    required this.type,
    required this.distance,
    required this.notes,
    required this.noPassengers,
    required this.userName,
    required this.userImage,
    this.status,   
    this.driverId, 
    this.review,   
    this.paymentWay = "cash", // القيمة الافتراضية
  });

  factory GetAllOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetAllOrdersModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      userPhone: json['userPhone'] ?? "No Phone",
      userName: json['userName'] ?? "Unknown User",
      userImage: json['userImage'] ??
          "https://tse1.mm.bing.net/th/id/OIP.0OL9oXb9QieUmjjSoWf-6gHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      fromLatLng: LatLngModel.fromJson(json['fromLatLng']),
      toLatLng: LatLngModel.fromJson(json['toLatLng']),
      expectedPrice: (json['expectedPrice'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] ?? '',
      noPassengers: json['noPassengers'] ?? 0,
      status: json['status'],          
      driverId: json['driverid'],      
      review: json['review'],          
      paymentWay: json['paymentWay'] ?? "cash", // 🔥 القيمة الافتراضية
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "userPhone": userPhone,
      "date": date.toIso8601String(),
      "from": from,
      "to": to,
      "fromLatLng": fromLatLng.toJson(),
      "toLatLng": toLatLng.toJson(),
      "expectedPrice": expectedPrice,
      "type": type,
      "distance": distance,
      "notes": notes,
      "noPassengers": noPassengers,
      "userName": userName,
      "userImage": userImage,
      "status": status,        
      "driverid": driverId,    
      "review": review,        
      "paymentWay": paymentWay // 🔥 هيكون دايمًا موجود
    };
  }

  String get formattedTime {
    return DateFormat('HH:mm').format(date); 
  }

  String get formattedDate {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

class LatLngModel {
  final double lat;
  final double lng;

  LatLngModel({required this.lat, required this.lng});

  factory LatLngModel.fromJson(Map<String, dynamic> json) {
    return LatLngModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"lat": lat, "lng": lng};
  }
}
