class CarModel {
  final int id;
  final String carPhoto;
  final String licenseFront;
  final String licenseBack;
  final String carBrand;
  final String carModel;
  final String carColor;
  final String plateNumber;
  final int driverId;

  CarModel({
    required this.id,                   
    required this.carPhoto,
    required this.licenseFront,
    required this.licenseBack,
    required this.carBrand,
    required this.carModel,
    required this.carColor,
    required this.plateNumber,
    required this.driverId,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "carPhoto": carPhoto,
      "licenseFront": licenseFront,
      "licenseBack": licenseBack,
      "carBrand": carBrand,
      "carModel": carModel,
      "carColor": carColor,
      "plateNumber": plateNumber,
      "driverId": driverId,
    };
  }

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json["id"],
      carPhoto: json["carPhoto"],
      licenseFront: json["licenseFront"],
      licenseBack: json["licenseBack"],
      carBrand: json["carBrand"],
      carModel: json["carModel"],
      carColor: json["carColor"],
      plateNumber: json["plateNumber"],
      driverId: json["driverId"],
    );
  }
}
  