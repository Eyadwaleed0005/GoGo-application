part of 'location_field_cubit.dart';

class LocationFieldState {
  final String? initialLocationName;
  final bool hasCoordinates;
  final MapSuggestion? selectedSuggestion;

  const LocationFieldState({
    this.initialLocationName,
    this.hasCoordinates = false,
    this.selectedSuggestion,
  });

  LocationFieldState copyWith({
    String? initialLocationName,
    bool? hasCoordinates,
    MapSuggestion? selectedSuggestion,
  }) {
    return LocationFieldState(
      initialLocationName: initialLocationName ?? this.initialLocationName,
      hasCoordinates: hasCoordinates ?? this.hasCoordinates,
      selectedSuggestion: selectedSuggestion ?? this.selectedSuggestion,
    );
  }
}

class LocationFieldInitial extends LocationFieldState {
  const LocationFieldInitial() : super();
}
