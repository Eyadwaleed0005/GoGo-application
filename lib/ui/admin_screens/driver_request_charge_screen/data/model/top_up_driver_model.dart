import 'dart:convert';

class TopUpDriver {
  final int chargeId;   
  final int driverId;
  final String name;
  final String image;

  TopUpDriver({
    required this.chargeId,
    required this.driverId,
    required this.name,
    required this.image,
  });

  factory TopUpDriver.fromJson(Map<String, dynamic> json) {
    return TopUpDriver(
      chargeId: json['id'],        
      driverId: json['driverId'],
      name: json['name'] ?? "",
      image: json['image'] ?? "",
    );
  }
}

// -----------------------------
// مثال على تحويل JSON إلى لستة
// -----------------------------
void main() {
  String jsonStr = '''
  {
    "\$id": "1",
    "\$values": [
      {
        "\$id": "2",
        "id": 1,
        "driverId": 21,
        "name": "Driver Test",
        "image": "https://i.ibb.co/0RwxH3n1/OIP-2.webp"
      },
      {
        "\$id": "4",
        "id": 2,
        "driverId": 21,
        "name": "Driver Test",
        "image": "https://i.ibb.co/MDw6YqcB/OIP-1.webp"
      }
    ]
  }
  ''';
  final data = jsonDecode(jsonStr);
  final List<dynamic> values = data['\$values'];

  List<TopUpDriver> drivers =
      values.map((item) => TopUpDriver.fromJson(item)).toList();

  for (var d in drivers) {
    print('DriverId: ${d.driverId}, Name: ${d.name}, Image: ${d.image}');
  }
}
