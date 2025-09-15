import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit.dart';
import 'choose_from_map_button.dart';
import '../suggestions_list.dart';

class LocationSearchBottomSheet {
  static Future<MapSuggestion?> show({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required void Function(MapSuggestion) onSelected,
    required String initialLocationName,
  }) async {
    MapSuggestion? selected;

    return await showModalBottomSheet<MapSuggestion>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return BlocProvider(
          create: (_) => SearchCubit(MapRepository()),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: TextStyles.font10BlackMedium()),
                      SizedBox(height: 20.h),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Search for a place...",
                          fillColor: ColorPalette.mainColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: ColorPalette.textColor1),
                                  onPressed: () {
                                    controller.clear();
                                    setState(() {}); 
                                  },
                                )
                              : null,
                        ),
                        onChanged: (pattern) async {
                          if (pattern.trim().isEmpty) {
                            setState(() {}); 
                            return;
                          }
                          await context
                              .read<SearchCubit>()
                              .searchPlaces(pattern);
                          setState(() {});
                        },
                      ),

                      SizedBox(height: 20.h),
                      ChooseFromMapButton(
                        controller: controller,
                        onSelected: (picked) {
                          selected = picked;
                          onSelected(picked);
                        },
                        onPicked: (picked) {
                          selected = picked;
                        },
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: SuggestionsList(
                          controller: controller,
                          onSelected: (s) {
                            selected = s;
                            onSelected(s);
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.mainColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context, selected);
                          },
                          child: Text(
                            "Done",
                            style: TextStyles.font11blackSemiBold(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
