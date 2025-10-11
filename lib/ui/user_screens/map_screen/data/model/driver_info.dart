class DriverInfo {
  final int id;
  final String driverPhoto;
  final String driverFullname;
  final String email;
  final String userId;
  final double review; 
  final String phoneNumber;

  DriverInfo({
    this.id = 0,
    this.driverPhoto = "",
    this.driverFullname = "",
    this.email = "",
    this.userId = "",
    this.review = 0.0,
    this.phoneNumber = "",
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'] ?? 0,
      driverPhoto: json['driverPhoto'] ?? "",
      driverFullname: json['driverFullname'] ?? "",
      email: json['email'] ?? "",
      userId: json['userId'] ?? "",
      review: (json['review'] as num?)?.toDouble() ?? 0.0, // ✅ يحول Double
      phoneNumber: json['phoneNumber']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverPhoto': driverPhoto,
      'driverFullname': driverFullname,
      'email': email,
      'userId': userId,
      'review': review,
      'phoneNumber': phoneNumber,
    };
  }
}
