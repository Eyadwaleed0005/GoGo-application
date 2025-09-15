class UserDriverResponseModel {
  final String userId;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String token;
  final String userType;

  UserDriverResponseModel({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.token,
    required this.userType,
  });

  factory UserDriverResponseModel.fromJson(Map<String, dynamic> json) {
    return UserDriverResponseModel(
      userId: json["userId"] ?? '',
      displayName: json["dispalyName"] ?? '',
      email: json["email"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      token: json["token"] ?? '',
      userType: json["userType"] ?? '',
    );
  }
}
