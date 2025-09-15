import '../../data/model/map_suggestion_model.dart';

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
