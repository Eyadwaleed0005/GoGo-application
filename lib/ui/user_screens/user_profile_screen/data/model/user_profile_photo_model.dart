class UserProfilePhotoModel {
  final String imageUrl;

  UserProfilePhotoModel({required this.imageUrl});

  factory UserProfilePhotoModel.fromJson(Map<String, dynamic> json) {
    return UserProfilePhotoModel(
      imageUrl: json['image'] ?? "",
    );
  }
}
