import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    if (isClosed) return; // لو الكيوبت اتقفل خلاص مانعملش حاجة
    emit(LocationLoading());

    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!isClosed) emit(LocationError("خدمة تحديد الموقع غير مفعلة"));
        return;
      }

      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          if (!isClosed) emit(LocationError("تم رفض إذن الموقع"));
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        if (!isClosed) emit(LocationError("إذن الموقع مرفوض بشكل دائم"));
        return;
      }

      final geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      final mb.Point currentPoint = mb.Point(
        coordinates: mb.Position(position.longitude, position.latitude),
      );

      String placeName = "موقعي الحالي";
      try {
        final placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          placeName =
              "${place.street ?? ""}, ${place.locality ?? ""}, ${place.country ?? ""}";
        }
      } catch (_) {
        placeName = "موقعي الحالي";
      }

      if (!isClosed) {
        emit(LocationLoaded(
          currentLocation: currentPoint,
          address: placeName,
          latitude: position.latitude,
          longitude: position.longitude,
        ));
      }
    } catch (e) {
      if (!isClosed) emit(LocationError("خطأ في تحديد الموقع: $e"));
    }
  }
}
