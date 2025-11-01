import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 🔹 الحالات الأساسية لإدارة حالة الخريطة
abstract class MapState {}

class MapInitial extends MapState {}

class MapReady extends MapState {
  final GoogleMapController map;
  MapReady(this.map);
}

class MapMoved extends MapState {
  final LatLng center;
  MapMoved(this.center);
}

class MapRouteDrawn extends MapState {
  final List<LatLng> points;
  MapRouteDrawn(this.points);
}

class MapPlaceSelected extends MapState {
  final String placeName;
  MapPlaceSelected(this.placeName);
}

class MapPinUpdated extends MapState {
  final LatLng point;
  final String placeName;
  MapPinUpdated(this.point, this.placeName);
}

/// ✅ تحديث الموقع الحالي للمستخدم
class MapCurrentLocationUpdated extends MapState {
  final LatLng location;
  MapCurrentLocationUpdated(this.location);
}

/// ✅ تحديث ماركرات السائقين
class MapDriversUpdated extends MapState {
  final Set<Marker> drivers;
  MapDriversUpdated(this.drivers);
}

/// 🛰️ تتبع حي بدأ
class MapTrackingStarted extends MapState {}

/// 🛰️ تتبع حي توقف
class MapTrackingStopped extends MapState {}

/// ⚠️ خطأ أثناء تشغيل التتبع أو الخريطة
class MapError extends MapState {
  final String message;
  MapError(this.message);
}
