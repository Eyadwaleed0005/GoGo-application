import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class PinkModeSwitchWidget extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const PinkModeSwitchWidget({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PinkModeSwitchWidget> createState() => _PinkModeSwitchWidgetState();
}

class _PinkModeSwitchWidgetState extends State<PinkModeSwitchWidget> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _checkGender();
  }

  Future<void> _checkGender() async {
    final gender = await SecureStorageHelper.getdata(
      key: SecureStorageKeys.gender,
    );

    setState(() {
      _visible = (gender == null || gender.toLowerCase() == "female");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return Row(
      children: [
        AnimatedToggleSwitch.dual(
          current: widget.value,
          first: false,
          second: true,
          spacing: 60.0.w,
          style: ToggleStyle(
            backgroundColor: ColorPalette.backgroundColor,
            borderColor: widget.value ? Colors.green : ColorPalette.pinkMode,
            indicatorColor: widget.value ? Colors.green : ColorPalette.pinkMode,
            borderRadius: BorderRadius.all(Radius.circular(30.r)),
          ),
          onChanged: widget.onChanged,
          iconBuilder: (value) => value
              ? const Icon(
                  Icons.check_circle,
                  color: ColorPalette.backgroundColor,
                )
              : const Icon(Icons.favorite, color: ColorPalette.backgroundColor),
          textBuilder: (value) => Center(
            child: Text(
              value ? "ON".tr() : "OFF".tr(),
              style: TextStyles.font8pinkSemiBold().copyWith(
                color: value ? Colors.green : ColorPalette.pinkMode,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        horizontalSpace(12),
        Text(
          "Pink_Mode".tr(),
          style: TextStyles.font15whitebold().copyWith(
            color: widget.value ? Colors.green : ColorPalette.pinkMode,
          ),
        ),
      ],
    );
  }
}
