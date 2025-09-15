import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

abstract class MapState {}

class MapInitial extends MapState {}

class MapReady extends MapState {
  final mb.MapboxMap map;
  MapReady(this.map);
}

class MapMoved extends MapState {
  final mb.Point center;
  MapMoved(this.center);
}

class MapRouteDrawn extends MapState {
  final List<mb.Point> points;
  MapRouteDrawn(this.points);
}

class MapPlaceSelected extends MapState {
  final String placeName;
  MapPlaceSelected(this.placeName);
}

class MapPinUpdated extends MapState {
  final mb.Point point;
  final String placeName;
  MapPinUpdated(this.point, this.placeName);
}
