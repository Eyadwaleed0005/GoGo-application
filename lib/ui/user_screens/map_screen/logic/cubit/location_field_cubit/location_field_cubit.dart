import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_cubit.dart';
import 'package:flutter/material.dart';

part 'location_field_state.dart';

class LocationFieldCubit extends Cubit<LocationFieldState> {
  final TextEditingController controller;
  final bool isFromField;
  final RouteCubit routeCubit;
  final MapRepository mapRepository;

  LocationFieldCubit({
    required this.controller,
    required this.isFromField,
    required this.routeCubit,
    required this.mapRepository,
  }) : super(LocationFieldInitial()) {
    controller.addListener(_onTextChanged);

    // ❌ تم إزالة التعبئة التلقائية بالموقع الحالي
    // علشان يبقى الحقل فاضي لما تفتح الخريطة أول مرة
  }

  void _onTextChanged() {
    if (isClosed) return;

    final text = controller.text.trim();

    if (state.initialLocationName != null &&
        text != state.initialLocationName) {
      if (isFromField) {
        routeCubit.setFromPoint(null);
      } else {
        routeCubit.setToPoint(null);
      }

      if (!isClosed) {
        emit(state.copyWith(
          initialLocationName: null,
          hasCoordinates: false,
        ));
      }
    }

    // ❌ كمان هنوقف محاولة تحديد الموقع لو المستخدم كتب "الموقع الحالي"
    // علشان ما يتعبّاش تلقائيًا
  }

  /// ✅ دالة تحديد الموقع الحالي (تُستدعى فقط يدويًا لو حبيت تضيف زر)
  Future<void> setCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (isClosed) return;

    final point = LatLng(pos.latitude, pos.longitude);

    String placeName = await mapRepository.getPlaceName(point);
    placeName = _removeNumbers(placeName);

    if (placeName.isEmpty || placeName == "موقع غير معروف") {
      placeName = "الموقع الحالي";
    }

    controller.text = placeName;

    final suggestion = MapSuggestion(
      id: "current_location",
      name: placeName,
      latitude: pos.latitude,
      longitude: pos.longitude,
    );

    if (isFromField) {
      routeCubit.setFromPoint(point);
    } else {
      routeCubit.setToPoint(point);
    }

    if (!isClosed) {
      emit(state.copyWith(
        initialLocationName: placeName,
        hasCoordinates: true,
        selectedSuggestion: suggestion,
      ));
    }
  }

  void onSuggestionSelected(MapSuggestion suggestion) {
    if (isClosed) return;

    final cleanName = _removeNumbers(suggestion.name);
    controller.text = cleanName;

    final point = LatLng(suggestion.latitude, suggestion.longitude);

    if (isFromField) {
      routeCubit.setFromPoint(point);
    } else {
      routeCubit.setToPoint(point);
    }

    if (!isClosed) {
      emit(state.copyWith(
        initialLocationName: cleanName,
        hasCoordinates: true,
        selectedSuggestion: MapSuggestion(
          id: suggestion.id,
          name: cleanName,
          latitude: suggestion.latitude,
          longitude: suggestion.longitude,
        ),
      ));
    }
  }

  String _removeNumbers(String text) {
    return text.replaceAll(RegExp(r'\d+'), '').trim();
  }

  @override
  Future<void> close() {
    controller.removeListener(_onTextChanged);
    return super.close();
  }
}
