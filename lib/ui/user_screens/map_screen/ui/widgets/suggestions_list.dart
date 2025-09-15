import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_state.dart';

class SuggestionsList extends StatelessWidget {
  final TextEditingController controller;
  final Function(MapSuggestion) onSelected;

  const SuggestionsList({
    super.key,
    required this.controller,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          return ListView.separated(
            itemCount: state.suggestions.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 0, 
            ),
            itemBuilder: (context, index) {
              final suggestion = state.suggestions[index];
              return InkWell(
                onTap: () {
                  controller.text = suggestion.name;
                  onSelected(suggestion);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorPalette.mainColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.place,
                          color: ColorPalette.red,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          suggestion.name,
                          style: TextStyles.font10BlackMedium(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
