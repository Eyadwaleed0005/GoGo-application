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
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final mapboxSuggestions = await repository.getPlaceSuggestions(query);
      final customSuggestions = CustomLocationService.searchCustomLocations(
        query,
      );

      final allSuggestions = [...customSuggestions, ...mapboxSuggestions];

      emit(SearchLoaded(allSuggestions));
    } catch (e) {
      emit(SearchError("فشل في جلب الاقتراحات: $e"));
    }
  }

  /// 🟢 تجيب أول مكان مطابق للنص مباشرة
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
