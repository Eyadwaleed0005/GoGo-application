import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelperTrips {
  /// Save trip data
  static Future<void> saveTripData({
    required double customerLat,
    required double customerLng,
    required double destinationLat,
    required double destinationLng,
    required String userPhone,
    required int orderId,
    required String customerName,
    required double price, 
    bool isOnTrip = true,
    bool isOnTripTwo = false,
    String? tripType,
    String? passengers,
    String? distance,
    DateTime? time, 
    String? notes,
    String? userImage,
    String? fromPlace,
    String? toPlace,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String formattedPhone = userPhone;
    if (formattedPhone.startsWith("0")) {
      formattedPhone = "+20${formattedPhone.substring(1)}";
    } else if (!formattedPhone.startsWith("+")) {
      formattedPhone = "+$formattedPhone";
    }

    await prefs.setDouble(SharedPreferenceKeys.customerLat, customerLat);
    await prefs.setDouble(SharedPreferenceKeys.customerLng, customerLng);
    await prefs.setDouble(SharedPreferenceKeys.destinationLat, destinationLat);
    await prefs.setDouble(SharedPreferenceKeys.destinationLng, destinationLng);
    await prefs.setString(SharedPreferenceKeys.userPhone, formattedPhone);
    await prefs.setInt(SharedPreferenceKeys.orderId, orderId);
    await prefs.setString(SharedPreferenceKeys.customerName, customerName);
    await prefs.setDouble(SharedPreferenceKeys.priceTrip, price); 
    await prefs.setBool(SharedPreferenceKeys.isOnTrip, isOnTrip);
    await prefs.setBool(SharedPreferenceKeys.isOnTripTwo, isOnTripTwo);

    if (tripType != null) await prefs.setString(SharedPreferenceKeys.tripType, tripType);
    if (passengers != null) await prefs.setString(SharedPreferenceKeys.passengers, passengers);
    if (distance != null) await prefs.setString(SharedPreferenceKeys.distance, distance);
    if (time != null) await prefs.setInt(SharedPreferenceKeys.time, time.millisecondsSinceEpoch);
    if (notes != null) await prefs.setString(SharedPreferenceKeys.notes, notes);
    if (userImage != null) await prefs.setString(SharedPreferenceKeys.userImage, userImage);
    if (fromPlace != null) await prefs.setString(SharedPreferenceKeys.fromPlace, fromPlace);
    if (toPlace != null) await prefs.setString(SharedPreferenceKeys.toPlace, toPlace);
  }

  static Future<Map<String, dynamic>?> getTripData() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnTrip = prefs.getBool(SharedPreferenceKeys.isOnTrip) ?? false;
    final isOnTripTwo = prefs.getBool(SharedPreferenceKeys.isOnTripTwo) ?? false;

    if (!isOnTrip && !isOnTripTwo) return null;

    final timeMillis = prefs.getInt(SharedPreferenceKeys.time);
    DateTime? time = timeMillis != null ? DateTime.fromMillisecondsSinceEpoch(timeMillis) : null;

    return {
      'customerLat': prefs.getDouble(SharedPreferenceKeys.customerLat),
      'customerLng': prefs.getDouble(SharedPreferenceKeys.customerLng),
      'destinationLat': prefs.getDouble(SharedPreferenceKeys.destinationLat),
      'destinationLng': prefs.getDouble(SharedPreferenceKeys.destinationLng),
      'userPhone': prefs.getString(SharedPreferenceKeys.userPhone),
      'orderId': prefs.getInt(SharedPreferenceKeys.orderId),
      'customerName': prefs.getString(SharedPreferenceKeys.customerName),
      'price': prefs.getDouble(SharedPreferenceKeys.priceTrip), 
      'isOnTrip': isOnTrip,
      'isOnTripTwo': isOnTripTwo,
      'tripType': prefs.getString(SharedPreferenceKeys.tripType),
      'passengers': prefs.getString(SharedPreferenceKeys.passengers),
      'distance': prefs.getString(SharedPreferenceKeys.distance),
      'time': time,
      'notes': prefs.getString(SharedPreferenceKeys.notes),
      'userImage': prefs.getString(SharedPreferenceKeys.userImage),
      'fromPlace': prefs.getString(SharedPreferenceKeys.fromPlace),
      'toPlace': prefs.getString(SharedPreferenceKeys.toPlace),
    };
  }

  static Future<void> clearTripData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceKeys.customerLat);
    await prefs.remove(SharedPreferenceKeys.customerLng);
    await prefs.remove(SharedPreferenceKeys.destinationLat);
    await prefs.remove(SharedPreferenceKeys.destinationLng);
    await prefs.remove(SharedPreferenceKeys.userPhone);
    await prefs.remove(SharedPreferenceKeys.orderId);
    await prefs.remove(SharedPreferenceKeys.customerName);
    await prefs.remove(SharedPreferenceKeys.priceTrip);
    await prefs.remove(SharedPreferenceKeys.tripType);
    await prefs.remove(SharedPreferenceKeys.passengers);
    await prefs.remove(SharedPreferenceKeys.distance);
    await prefs.remove(SharedPreferenceKeys.time);
    await prefs.remove(SharedPreferenceKeys.notes);
    await prefs.remove(SharedPreferenceKeys.userImage);
    await prefs.remove(SharedPreferenceKeys.fromPlace);
    await prefs.remove(SharedPreferenceKeys.toPlace);

    await prefs.setBool(SharedPreferenceKeys.isOnTrip, false);
    await prefs.setBool(SharedPreferenceKeys.isOnTripTwo, false);
  }

  /// Update trip stage
  static Future<void> updateTripStage({
    bool? isOnTrip,
    bool? isOnTripTwo,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (isOnTrip != null) {
      await prefs.setBool(SharedPreferenceKeys.isOnTrip, isOnTrip);
      if (isOnTrip) {
        await prefs.setBool(SharedPreferenceKeys.isOnTripTwo, false);
      }
    }

    if (isOnTripTwo != null) {
      await prefs.setBool(SharedPreferenceKeys.isOnTripTwo, isOnTripTwo);
      if (isOnTripTwo) {
        await prefs.setBool(SharedPreferenceKeys.isOnTrip, false);
      }
    }
  }
}
