import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    if (isClosed) return;
    emit(LocationLoading());

    try {
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationError("خدمة تحديد الموقع غير مفعّلة"));
        return;
      }

      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          emit(LocationError("تم رفض إذن الموقع"));
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        emit(LocationError("تم رفض إذن الموقع بشكل دائم"));
        return;
      }

      final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      final currentLatLng = LatLng(position.latitude, position.longitude);
      String placeName = "موقعي الحالي";

      try {
        final placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          placeName = [
            place.name,
            place.subAdministrativeArea,
            place.administrativeArea,
            place.country,
          ].where((e) => e != null && e.isNotEmpty).join('، ');
        }
      } catch (_) {}

      emit(LocationLoaded(
        currentLocation: currentLatLng,
        address: placeName,
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      emit(LocationError("حدث خطأ أثناء تحديد الموقع: $e"));
    }
  }

  void setSelectedSuggestion(MapSuggestion suggestion) {
    if (isClosed) return;

    emit(LocationLoaded(
      currentLocation: LatLng(suggestion.latitude, suggestion.longitude),
      address: suggestion.name, 
      latitude: suggestion.latitude,
      longitude: suggestion.longitude,
    ));
  }
}
