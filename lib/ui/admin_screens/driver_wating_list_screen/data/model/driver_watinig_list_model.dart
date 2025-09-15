import 'dart:convert';

class DriverWaitingListResponse {
  final List<DriverWaitingListModel> drivers;

  DriverWaitingListResponse({required this.drivers});

  factory DriverWaitingListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['\$values'] as List;
    List<DriverWaitingListModel> driversList =
        list.map((e) => DriverWaitingListModel.fromJson(e)).toList();

    return DriverWaitingListResponse(drivers: driversList);
  }

  Map<String, dynamic> toJson() {
    return {
      "\$values": drivers.map((e) => e.toJson()).toList(),
    };
  }

  static DriverWaitingListResponse fromRawJson(String str) =>
      DriverWaitingListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class DriverWaitingListModel {
  final int id;
  final String driverFullname;
  final String email;
  final String status;
  final String userId; 

  DriverWaitingListModel({
    required this.id,
    required this.driverFullname,
    required this.email,
    required this.status,
    required this.userId, 
  });

  factory DriverWaitingListModel.fromJson(Map<String, dynamic> json) {
    return DriverWaitingListModel(
      id: json['id'],
      driverFullname: json['driverFullname'],
      email: json['email'],
      status: json['status'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "driverFullname": driverFullname,
      "email": email,
      "status": status,
      "userId": userId, 
    };
  }
}
