import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit/search_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit/search_state.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/suggestions_skeleton.dart';

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
          return const SuggestionsSkeleton();
        } else if (state is SearchLoaded) {
          return ListView.separated(
            itemCount: state.suggestions.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey, thickness: 0.5, height: 0),
            itemBuilder: (context, index) {
              final suggestion = state.suggestions[index];

              return InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  final displayName = suggestion.name;
                  final repo = MapRepository();
                  final details = await repo.getPlaceDetails(suggestion.id);
                  if (!context.mounted) return;
                  if (details != null &&
                      details.latitude != 0 &&
                      details.longitude != 0) {
                    final selectedPlace = MapSuggestion(
                      id: suggestion.id,
                      name: displayName, 
                      latitude: details.latitude,
                      longitude: details.longitude,
                      address: displayName,
                    );
                    controller.text = displayName;
                    Navigator.pop(context, selectedPlace);
                    onSelected(selectedPlace);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'حدث خطأ أثناء جلب تفاصيل المكان، حاول مرة أخرى.',
                        ),
                        backgroundColor: Colors.red.shade700,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 4.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          suggestion.name,
                          style: TextStyles.font10BlackMedium(),
                          softWrap: true,
                          overflow: TextOverflow.visible,
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
