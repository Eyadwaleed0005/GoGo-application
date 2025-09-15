import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class SectionSwitcher extends StatefulWidget {
  final List<Widget> sections;

  const SectionSwitcher({super.key, required this.sections});

  @override
  _SectionSwitcherState createState() => _SectionSwitcherState();
}

class _SectionSwitcherState extends State<SectionSwitcher> {
  int currentSection = 0;

  void nextSection() {
    setState(() {
      currentSection = (currentSection + 1) % widget.sections.length;
    });
  }

  void previousSection() {
    setState(() {
      currentSection =
          (currentSection - 1 + widget.sections.length) %
          widget.sections.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.sections[currentSection],

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentSection > 0)
                ElevatedButton(
                  onPressed: previousSection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.buttons,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: TextStyles.font10blackMedium(),
                  ),
                )
              else
                horizontalSpace(90),

              if (currentSection < widget.sections.length - 1)
                ElevatedButton(
                  onPressed: nextSection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.buttons,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text('Next', style: TextStyles.font10blackMedium()),
                )
              else
                SizedBox(width: 90.w),
            ],
          ),
        ],
      ),
    );
  }
}
