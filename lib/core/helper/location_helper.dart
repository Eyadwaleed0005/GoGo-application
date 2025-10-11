import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';

class LocationHelper {
  final MapRepository _repo = MapRepository();

  Future<(LatLng?, String?)> getCurrentLocationWithName() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return (null, null);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return (null, null);
    }
    if (permission == LocationPermission.deniedForever) return (null, null);

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final point = LatLng(pos.latitude, pos.longitude);

    String name = await _repo.getPlaceName(point);
    if (name.isEmpty) name = "الموقع الحالي";
    else name = "الموقع الحالي - $name";

    return (point, name);
  }
}
