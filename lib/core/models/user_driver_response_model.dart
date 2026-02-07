class UserDriverResponseModel {
  final String userId;
  final String dispalyName;
  final String email;
  final String phoneNumber;
  final String token;
  final String userType;
  final String gender;

  UserDriverResponseModel({
    required this.userId,
    required this.dispalyName,
    required this.email,
    required this.phoneNumber,
    required this.token,
    required this.userType,
    required this.gender,
  });

  factory UserDriverResponseModel.fromJson(Map<String, dynamic> json) {
    return UserDriverResponseModel(
      userId: json["userId"] ?? '',
      dispalyName: json["dispalyName"] ?? '',
      email: json["email"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      token: json["token"] ?? '',
      userType: json["userType"] ?? '',
      gender: json["gender"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "displayName": dispalyName,
      "email": email,
      "phoneNumber": phoneNumber,
      "token": token,
      "userType": userType,
      "gender": gender,
    };
  }
}
