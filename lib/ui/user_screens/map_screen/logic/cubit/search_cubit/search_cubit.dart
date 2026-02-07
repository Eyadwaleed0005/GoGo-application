import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import '../../../data/model/map_suggestion_model.dart';
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
      final suggestions = await repository.getPlaceSuggestions(query);

      if (!isClosed) emit(SearchLoaded(suggestions));
    } catch (e) {
      if (!isClosed) emit(SearchError("فشل في جلب الاقتراحات"));
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
