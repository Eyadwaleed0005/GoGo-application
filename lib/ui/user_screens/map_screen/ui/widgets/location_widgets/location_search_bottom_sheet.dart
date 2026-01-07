import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit/search_cubit.dart';
import 'choose_from_map_button.dart';
import '../suggestions_list.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
              final stt.SpeechToText speech = stt.SpeechToText();
              bool isListening = false;

              Future<void> startListening() async {
                bool available = await speech.initialize();
                if (available) {
                  setState(() => isListening = true);
                  speech.listen(
                    onResult: (result) async {
                      controller.text = result.recognizedWords;
                      if (controller.text.isNotEmpty) {
                        await context.read<SearchCubit>().searchPlaces(
                              controller.text,
                            );
                      }
                      setState(() {});
                    },
                  );
                }
              }

              void stopListening() {
                speech.stop();
                setState(() => isListening = false);
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: TextStyles.font10BlackMedium()),
                      SizedBox(height: 20.h),
                      TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: ColorPalette.mainColor,
                          selectionColor:
                              ColorPalette.mainColor.withOpacity(0.25),
                          selectionHandleColor: ColorPalette.mainColor,
                        ),
                        child: TextField(
                          controller: controller,
                          cursorColor: ColorPalette.mainColor,
                          decoration: InputDecoration(
                            hintText: "search_for_place".tr(),
                            filled: true,
                            fillColor: Colors.white,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: ColorPalette.filedInner,
                                width: 1.w,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: ColorPalette.filedInner,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                color: ColorPalette.mainColor,
                                width: 1.2,
                              ),
                            ),

                            prefixIcon: const Icon(
                              Icons.search,
                              color: ColorPalette.black,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.text.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: ColorPalette.textColor1,
                                    ),
                                    onPressed: () {
                                      controller.clear();
                                      setState(() {});
                                    },
                                  ),
                                IconButton(
                                  icon: Icon(
                                    isListening ? Icons.mic : Icons.mic_none,
                                    color: isListening
                                        ? Colors.red
                                        : ColorPalette.textColor1,
                                  ),
                                  onPressed: () {
                                    if (isListening) {
                                      stopListening();
                                    } else {
                                      startListening();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          onChanged: (pattern) async {
                            if (pattern.trim().isEmpty) {
                              setState(() {});
                              return;
                            }
                            await context.read<SearchCubit>().searchPlaces(
                                  pattern,
                                );
                            setState(() {});
                          },
                        ),
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
                            "done".tr(),
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
