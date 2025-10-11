import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_field_cubit/location_field_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_search_bottom_sheet.dart';

class LocationSearchField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(MapSuggestion) onSelected;
  final String? Function(String?)? validator;
  final Color borderColor;
  final bool isFromField;

  const LocationSearchField({
    super.key,
    required this.label,
    required this.controller,
    required this.onSelected,
    this.validator,
    this.borderColor = ColorPalette.fieldStroke,
    this.isFromField = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationFieldCubit(
        controller: controller,
        isFromField: isFromField,
        routeCubit: context.read<RouteCubit>(),
        mapRepository: MapRepository(),
      ),
      child: BlocBuilder<LocationFieldCubit, LocationFieldState>(
        builder: (context, state) {
          final cubit = context.read<LocationFieldCubit>();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: GestureDetector(
              onTap: () {
                LocationSearchBottomSheet.show(
                  context: context,
                  label: label,
                  controller: controller,
                  onSelected: (suggestion) {
                    cubit.onSuggestionSelected(suggestion);
                    onSelected(suggestion);
                  },
                  initialLocationName: state.initialLocationName ?? "",
                );
              },
              child: AbsorbPointer(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // ✅ مهم علشان السطر الجديد يظهر مظبوط
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 16.w,
                      height: 14.w,
                      margin: EdgeInsets.only(right: 8.w, top: 10.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.hasCoordinates ? Colors.green : Colors.red,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Center(
                        child: Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(5),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        validator: validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (_) => Form.of(context).validate(),

                        // ✅ النص ينزل سطر لو طويل
                        minLines: 1,
                        maxLines: null,
                        expands: false,

                        style: TextStyles.font10BlackMedium().copyWith(
                          height: 1.4, // راحة في القراءة
                        ),

                        decoration: InputDecoration(
                          labelText: label,
                          alignLabelWithHint: true, // ✅ يخلي الليبل فوق في حال النص طويل
                          labelStyle: TextStyles.font10BlackMedium(),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: state.hasCoordinates
                                ? ColorPalette.green
                                : ColorPalette.red,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 14.h,
                          ),
                          errorStyle: TextStyle(
                            fontSize: 9.sp,
                            height: 0.8.h,
                            color: Colors.red,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.w,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.w,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
