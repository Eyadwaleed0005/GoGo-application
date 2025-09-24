import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/services/custom_location_servicse.dart';
import '../../data/model/map_suggestion_model.dart';
import '../../data/repo/map_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MapRepository repository;

  SearchCubit(this.repository) : super(SearchInitial());

  Future<void> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      if (!isClosed) emit(SearchInitial());
      return;
    }

    if (!isClosed) emit(SearchLoading());

    try {
      final mapboxSuggestions = await repository.getPlaceSuggestions(query);
      final customSuggestions = CustomLocationService.searchCustomLocations(query);

      final allSuggestions = [...customSuggestions, ...mapboxSuggestions];

      if (!isClosed) emit(SearchLoaded(allSuggestions));
    } catch (e) {
      if (!isClosed) emit(SearchError("فشل في جلب الاقتراحات: $e"));
    }
  }

  Future<MapSuggestion?> searchFirstMatch(String query) async {
    try {
      final suggestions = await repository.getPlaceSuggestions(query);
      if (suggestions.isNotEmpty) {
        return suggestions.first;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
