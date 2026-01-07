import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gogo/core/helper/address_sanitizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';

class MapRepository {
  Timer? _debounceTimer;
  String? _lastQuery;
  List<MapSuggestion>? _lastSuggestions;

  Future<List<MapSuggestion>> getPlaceSuggestions(String query) async {
    if (query.isEmpty) return [];

    if (_lastQuery == query && _lastSuggestions != null) {
      return _lastSuggestions!;
    }

    _debounceTimer?.cancel();
    final completer = Completer<List<MapSuggestion>>();

    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      try {
        final response = await DioHelper.getData(
          url: EndPoints.googlePlacesAutocomplete,
          query: {
            'input': query,
            'key': EndPoints.googleMapsKey,
            'language': 'ar',
            'components': 'country:eg',
          },
        );

        final List predictions = response.data['predictions'] ?? [];
        final suggestions = predictions.map<MapSuggestion>((item) {
          final raw = (item['description'] ?? '').toString();
          final cleaned = AddressSanitizer.sanitizeGoogleAddress(raw);

          return MapSuggestion(
            id: item['place_id'] ?? '',
            name: cleaned,
            latitude: 0,
            longitude: 0,
          );
        }).toList();

        _lastQuery = query;
        _lastSuggestions = suggestions;
        completer.complete(suggestions);
      } catch (_) {
        completer.complete([]);
      }
    });

    return completer.future;
  }

  Future<MapSuggestion?> getPlaceDetails(String placeId) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.googlePlaceDetails,
        query: {
          'place_id': placeId,
          'key': EndPoints.googleMapsKey,
          'language': 'ar',
        },
      );

      final result = response.data['result'];
      if (result == null) return null;

      final location = result['geometry']?['location'];

      String placeName = (result['name'] ??
              result['formatted_address'] ??
              result['vicinity'] ??
              '')
          .toString();

      placeName = AddressSanitizer.sanitizeGoogleAddress(placeName);

      return MapSuggestion(
        id: placeId,
        name: placeName,
        latitude: (location?['lat'] as num?)?.toDouble() ?? 0,
        longitude: (location?['lng'] as num?)?.toDouble() ?? 0,
        address: placeName,
      );
    } catch (_) {
      return null;
    }
  }

  String _sanitizeForEgyptDetailed(String raw) {
    var t = raw.trim();
    if (t.isEmpty) return 'موقع غير معروف';

    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();

    t = t.replaceAll(RegExp(r'\b[0-9A-Z]{3,}\+[0-9A-Z]{2,}\b'), '');
    t = t.replaceAll(RegExp(r'^[0-9A-Z]{3,}\+?[0-9A-Z]*\s*[,، ]*\s*'), '');

    t = t.replaceAll(
      RegExp(r'(جمهورية\s*مصر\s*العربية|مصر)\s*[،,]?\s*'),
      '',
    );
    t = t.replaceAll(RegExp(r'محافظة\s+\S+(\s+\S+)?\s*[،,]?\s*'), '');

    t = t.replaceAll(RegExp(r'\bقسم\s*(أول|ثاني|ثالث|رابع|خامس)?\b'), '');

    t = t.replaceAll(RegExp(r'\s*[،,]\s*'), '، ');
    t = t.replaceAll(RegExp(r'(،\s*){2,}'), '، ');
    t = t.replaceAll(RegExp(r'^\s*،\s*|\s*،\s*$'), '');
    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();

    return t.isEmpty ? 'موقع غير معروف' : t;
  }

  String _buildDetailedAddressFromGeocodeResult(Map<String, dynamic> result) {
    final components = (result['address_components'] as List?) ?? [];

    String? streetNumber;
    String? route;
    String? sublocality;
    String? locality;

    for (final c in components) {
      final comp = c as Map<String, dynamic>;
      final types = List<String>.from(comp['types'] ?? const []);
      final longName = (comp['long_name'] ?? '').toString().trim();
      if (longName.isEmpty) continue;

      if (types.contains('street_number')) streetNumber = longName;
      if (types.contains('route')) route = longName;

      if (types.contains('sublocality') ||
          types.contains('sublocality_level_1')) {
        sublocality ??= longName;
      }

      if (types.contains('locality')) locality ??= longName;
    }

    final line1Parts = <String>[];
    if (route != null && route.isNotEmpty) line1Parts.add(route);
    if (streetNumber != null && streetNumber.isNotEmpty) {
      line1Parts.add(streetNumber);
    }

    final line2Parts = <String>[];
    if (sublocality != null && sublocality.isNotEmpty) {
      line2Parts.add(sublocality);
    }
    if (locality != null && locality.isNotEmpty) line2Parts.add(locality);

    var line1 = line1Parts.join('، ').trim();
    var line2 = line2Parts.join('، ').trim();

    if (line1.isEmpty) {
      line1 = (result['formatted_address'] ?? '').toString();
    }

    line1 = _sanitizeForEgyptDetailed(line1);
    line2 = _sanitizeForEgyptDetailed(line2);

    if (line2 == line1) line2 = '';
    if (line1.isEmpty) line1 = 'موقع غير معروف';

    return line2.isEmpty ? line1 : '$line1، $line2';
  }

  Future<String> getPlaceName(LatLng point) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.googleGeocode,
        query: {
          'latlng': '${point.latitude},${point.longitude}',
          'key': EndPoints.googleMapsKey,
          'language': 'ar',
        },
      );

      final results = response.data['results'];
      if (results != null && results.isNotEmpty) {
        Map<String, dynamic>? best;

        for (final r in results) {
          final types = List<String>.from(r['types'] ?? []);
          if (types.contains('street_address') ||
              types.contains('route') ||
              types.contains('premise') ||
              types.contains('subpremise')) {
            best = Map<String, dynamic>.from(r);
            break;
          }
        }

        best ??= Map<String, dynamic>.from(results.first);

        final detailed = _buildDetailedAddressFromGeocodeResult(best);
        final cleaned = _sanitizeForEgyptDetailed(detailed);
        return cleaned.isEmpty ? 'موقع غير معروف' : cleaned;
      }
    } catch (_) {}

    return 'موقع غير معروف';
  }

  Future<({
    List<LatLng> routePoints,
    double distanceKm,
    double durationMin,
  })?> getRoute(LatLng from, LatLng to) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.googleDirections,
        query: {
          'origin': '${from.latitude},${from.longitude}',
          'destination': '${to.latitude},${to.longitude}',
          'key': EndPoints.googleMapsKey,
          'language': 'ar',
          'mode': 'driving',
        },
      );

      final data = response.data;
      if (data['routes'] == null || data['routes'].isEmpty) return null;

      final route = data['routes'][0];
      final overviewPolyline = route['overview_polyline']?['points'];
      if (overviewPolyline == null) return null;

      final points = await compute<String, List<LatLng>>(
        _decodePolyline,
        overviewPolyline,
      );

      final leg = route['legs']?[0];
      if (leg == null) return null;

      final distanceMeters =
          (leg['distance']?['value'] as num?)?.toDouble() ?? 0;
      final durationSeconds =
          (leg['duration']?['value'] as num?)?.toDouble() ?? 0;

      return (
        routePoints: points,
        distanceKm: distanceMeters / 1000,
        durationMin: durationSeconds / 60,
      );
    } catch (_) {
      return null;
    }
  }

  static List<LatLng> _decodePolyline(String polyline) {
    final List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
