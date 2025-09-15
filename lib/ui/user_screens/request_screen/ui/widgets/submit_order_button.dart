import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class SubmitOrderButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String Function() getFrom;
  final String Function() getTo;
  final mb.Point? Function() getFromLatLng;
  final mb.Point? Function() getToLatLng;
  final int Function() getPassengers;
  final String Function() getTripType;
  final String Function() getPrice;
  final String Function() getNotes;
  final double? Function()? getDistanceKm;     // ✅ إضافة
  final double? Function()? getDurationMin;   // ✅ إضافة

  const SubmitOrderButton({
    super.key,
    required this.formKey,
    required this.getFrom,
    required this.getTo,
    required this.getFromLatLng,
    required this.getToLatLng,
    required this.getPassengers,
    required this.getTripType,
    required this.getPrice,
    required this.getNotes,
    this.getDistanceKm,
    this.getDurationMin,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.mainColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final requestData = {
              "from": getFrom(),
              "to": getTo(),
              "fromLatLng": getFromLatLng() != null
                  ? {
                      "lat": getFromLatLng()!.coordinates.lat,
                      "lng": getFromLatLng()!.coordinates.lng,
                    }
                  : null,
              "toLatLng": getToLatLng() != null
                  ? {
                      "lat": getToLatLng()!.coordinates.lat,
                      "lng": getToLatLng()!.coordinates.lng,
                    }
                  : null,
              "passengers": getTripType() == "One Way"
                  ? getPassengers()
                  : null,
              "tripType": getTripType(),
              "price": getPrice(),
              "notes": getNotes().isNotEmpty ? getNotes() : null,
              "distanceKm": getDistanceKm != null ? getDistanceKm!() : null,    // ✅ إضافة
              "durationMin": getDurationMin != null ? getDurationMin!() : null, // ✅ إضافة
            };

            const encoder = JsonEncoder.withIndent('  ');
            print(encoder.convert(requestData));

            // هنا يمكن إرسال البيانات للـ API بدل الطباعة
          }
        },
        child: Text(
          "Find A Car",
          style: TextStyles.font11blackSemiBold(),
        ),
      ),
    );
  }
}
