import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          return Center(
            child: CircularProgressIndicator(
              color: ColorPalette.mainColor,
              strokeWidth: 2.w,
            ),
          );
        } else if (state is SearchLoaded) {
          return ListView.separated(
            itemCount: state.suggestions.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey, thickness: 0.5, height: 0),
            itemBuilder: (context, index) {
              final suggestion = state.suggestions[index];
              return InkWell(
                onTap: () {
                  controller.text = _cleanSuggestionName(suggestion.name);
                  onSelected(suggestion);
                  Navigator.pop(context, suggestion); 
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          color: ColorPalette.mainColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.place,
                          color: ColorPalette.red,
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _cleanSuggestionName(suggestion.name),
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

  String _cleanSuggestionName(String name) {
    return name.replaceAll(RegExp(r'\d+'), '').trim();
  }
}
