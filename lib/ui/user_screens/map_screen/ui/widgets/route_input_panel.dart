import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_input_panel_cubit/cubit/route_input_panel_cubit.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_search_field.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/RideRequestScreen.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class RouteInputPanel extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;

  RouteInputPanel({
    super.key,
    required this.fromController,
    required this.toController,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteInputPanelCubit, RouteInputPanelState>(
      listener: (context, state) {
        if (state is RouteInputPanelError) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.message.tr()),
          );
        } else if (state is RouteInputPanelSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RideRequestScreen(
                from: state.from,
                to: state.to,
                fromLatLng: state.fromLatLng,
                toLatLng: state.toLatLng,
                distanceKm: state.distanceKm,
                durationMin: state.durationMin,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<RouteInputPanelCubit>();
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.15,
          maxChildSize: 0.39,
          builder: (context, scrollController) {
            return Container(
              padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.r,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 60.w,
                        height: 4.h,
                        margin: EdgeInsets.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          color: ColorPalette.fieldStroke,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    LocationSearchField(
                      label: "from".tr(),
                      controller: fromController,
                      isFromField: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "please_select_start".tr();
                        }
                        return null;
                      },
                      onSelected: cubit.onFromSelected,
                    ),
                    verticalSpace(8),
                    LocationSearchField(
                      label: "to".tr(),
                      controller: toController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "please_select_destination".tr();
                        }
                        return null;
                      },
                      onSelected: cubit.onToSelected,
                    ),
                    verticalSpace(8),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: state is RouteInputPanelLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ColorPalette.mainColor,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalette.mainColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                cubit.submitRoute(
                                  context: context,
                                  fromController: fromController,
                                  toController: toController,
                                );
                              },
                              child: Text(
                                "make_car_order".tr(),
                                style: TextStyles.font11blackSemiBold(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
