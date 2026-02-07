class LocalUserModel {
  final String name;
  final String email;
  final String phone;

  LocalUserModel({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory LocalUserModel.fromMap(Map<String, String?> map) {
    return LocalUserModel(
      name: map['displayName'] ?? "Unknown",
      email: map['email'] ?? "Unknown",
      phone: map['phoneNumber'] ?? "Unknown",
    );
  }
}
