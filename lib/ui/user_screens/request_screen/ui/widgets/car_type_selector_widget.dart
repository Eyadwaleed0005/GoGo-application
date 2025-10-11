import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/textstyles.dart';

class CarTypeSelectorWidget extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const CarTypeSelectorWidget({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CarTypeSelectorWidget> createState() => _CarTypeSelectorWidgetState();
}

class _CarTypeSelectorWidgetState extends State<CarTypeSelectorWidget> {
  final List<Map<String, dynamic>> _options = [
    {
      "value": "taxi",
      "label": "car_type_taxi".tr(),
      "image": AppImage().taxi3,
      "color": Colors.orange,
    },
    {
      "value": "car",
      "label": "car_type_car".tr(),
      "image": AppImage().taxi5,
      "color": Colors.blueGrey,
    },
    {
      "value": "scooter",
      "label": "car_type_scooter".tr(),
      "image": AppImage().scotter,
      "color": Colors.deepOrange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _options.map((option) {
        final isSelected = widget.selectedValue == option["value"];

        return GestureDetector(
          onTap: () => widget.onChanged(option["value"]),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 70.w : 60.w,
                height: isSelected ? 70.w : 60.w,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected
                      ? option["color"].withOpacity(0.8)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: option["color"].withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: isSelected ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      option["image"],
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(option["label"], style: TextStyles.font15whitebold()),
            ],
          ),
        );
      }).toList(),
    );
  }
}
