import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:lottie/lottie.dart';

class TripTypeToggle extends StatefulWidget {
  final String? initialTripType; // لو مش متحددة هنخليها "One Way"
  final ValueChanged<String>? onChanged;
  final String carAnimation;
  final String deliveryAnimation;

  const TripTypeToggle({
    super.key,
    this.initialTripType,
    this.onChanged,
    required this.carAnimation,
    required this.deliveryAnimation,
  });

  @override
  State<TripTypeToggle> createState() => _TripTypeToggleState();
}

class _TripTypeToggleState extends State<TripTypeToggle> {
  late String tripType;

  bool get isDisabled => widget.onChanged == null;

  @override
  void initState() {
    super.initState();
    tripType = widget.initialTripType ?? "One Way"; // ديفولت Car Travel
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [
        tripType == "One Way",
        tripType == "Round Trip",
      ],
      onPressed: isDisabled
          ? null
          : (index) {
              final selected = index == 0 ? "One Way" : "Round Trip";
              setState(() {
                tripType = selected;
              });
              widget.onChanged?.call(selected);
            },
      borderRadius: BorderRadius.circular(12.r),
      borderColor: ColorPalette.fieldStroke,
      selectedBorderColor: ColorPalette.mainColor,
      fillColor: ColorPalette.mainColor.withOpacity(0.15),
      selectedColor: ColorPalette.mainColor,
      color: ColorPalette.starsColor,
      constraints: const BoxConstraints(minHeight: 90, minWidth: 110),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Lottie.asset(
                widget.carAnimation,
                animate: tripType == "One Way" && !isDisabled,
                repeat: true,
              ),
            ),
            verticalSpace(4),
            Text(
              "Car Travel",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlusJakartaSans',
                color: tripType == "One Way"
                    ? ColorPalette.buttons
                    : Colors.black,
              ),
            ),
            verticalSpace(13),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Lottie.asset(
                widget.deliveryAnimation,
                animate: tripType == "Round Trip" && !isDisabled,
                repeat: true,
              ),
            ),
            verticalSpace(4),
            Text(
              "Delivery",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlusJakartaSans',
                color: tripType == "Round Trip"
                    ? ColorPalette.buttons
                    : Colors.black,
              ),
            ),
            verticalSpace(13)
          ],
        ),
      ],
    );
  }
}
