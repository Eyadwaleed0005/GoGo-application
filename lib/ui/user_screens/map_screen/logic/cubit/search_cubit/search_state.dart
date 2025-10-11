import '../../../data/model/map_suggestion_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<MapSuggestion> suggestions;
  SearchLoaded(this.suggestions);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchListening extends SearchState {}

class SearchStopped extends SearchState {}

class SearchLocationLoaded extends SearchState {
  final MapSuggestion location;
  SearchLocationLoaded(this.location);
}
