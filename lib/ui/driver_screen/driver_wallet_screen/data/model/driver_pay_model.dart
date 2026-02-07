class DriverPayModel {
  final int driverId;
  final String name;
  final String image;

  DriverPayModel({
    required this.driverId,
    required this.name,
    required this.image,
  });

  factory DriverPayModel.fromJson(Map<String, dynamic> json) {
    return DriverPayModel(
      driverId: json['driverId'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'name': name,
      'image': image,
    };
  }
}
