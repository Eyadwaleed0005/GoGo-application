import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_ride_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'show_trip_state.dart';

class ShowTripCubit extends Cubit<ShowTripState> {
  final DriverRideRepository repository;
  ShowTripCubit(this.repository) : super(ShowTripInitial());

  Future<void> showTrip({
    required double customerLat,
    required double customerLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    emit(ShowTripLoading());
    try {
      // 🔹 تحديد موقع السائق الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final driverLat = position.latitude;
      final driverLng = position.longitude;

      // 🔹 المسار الأول: من السائق إلى العميل
      final route1 = await repository.getRoute(
        fromLat: driverLat,
        fromLng: driverLng,
        toLat: customerLat,
        toLng: customerLng,
        userPhone: '',
      );

      // 🔹 المسار الثاني: من العميل إلى الوجهة
      final route2 = await repository.getRoute(
        fromLat: customerLat,
        fromLng: customerLng,
        toLat: destinationLat,
        toLng: destinationLng,
        userPhone: '',
      );

      // 🔹 إنشاء الـ Polylines
      final polyline1 = Polyline(
        polylineId: const PolylineId('driver_to_customer'),
        color: const Color(0xFF1565C0),
        width: 5,
        points: route1.routeGeometry!.map((e) => LatLng(e[1], e[0])).toList(),
      );

      final polyline2 = Polyline(
        polylineId: const PolylineId('customer_to_destination'),
        color: const Color(0xFF2E7D32),
        width: 5,
        points: route2.routeGeometry!.map((e) => LatLng(e[1], e[0])).toList(),
      );

      // 🔹 إنشاء الأيقونات المخصصة
      final driverIcon = await _createPinMarker('أنت', Colors.blue);
      final customerIcon = await _createPinMarker('العميل', Colors.orange);
      final destinationIcon = await _createPinMarker('الوجهة', Colors.green);

      emit(ShowTripLoadedMulti(
        polyline1: polyline1,
        polyline2: polyline2,
        driverLat: driverLat,
        driverLng: driverLng,
        customerLat: customerLat,
        customerLng: customerLng,
        destinationLat: destinationLat,
        destinationLng: destinationLng,
        distance1Km: route1.distanceKm ?? 0,
        duration1Min: route1.durationMin ?? 0,
        distance2Km: route2.distanceKm ?? 0,
        duration2Min: route2.durationMin ?? 0,
        driverIcon: driverIcon,
        customerIcon: customerIcon,
        destinationIcon: destinationIcon,
      ));
    } catch (e) {
      emit(ShowTripError(e.toString()));
    }
  }

  /// 🔹 إنشاء Marker مخصص
  Future<BitmapDescriptor> _createPinMarker(String text, Color color) async {
    const double width = 160;
    const double height = 200;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(width / 2, height)
      ..quadraticBezierTo(width, height * 0.6, width / 2, height * 0.2)
      ..quadraticBezierTo(0, height * 0.6, width / 2, height)
      ..close();
    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(width / 2, height * 0.4),
      45,
      Paint()..color = Colors.white,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 38,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    textPainter.paint(
      canvas,
      Offset((width - textPainter.width) / 2,
          (height * 0.4 - textPainter.height / 2)),
    );

    final img = await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(Uint8List.view(data!.buffer));
  }

  LatLngBounds calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
