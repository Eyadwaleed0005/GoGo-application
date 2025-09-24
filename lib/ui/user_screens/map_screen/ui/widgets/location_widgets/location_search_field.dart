import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_search_bottom_sheet.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class LocationSearchField extends StatefulWidget {
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
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField>
    with SingleTickerProviderStateMixin {
  String? _initialLocationName;

  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isFromField) {
      _setCurrentLocation();
    }
    widget.controller.addListener(_onTextChanged);

    // ✅ أنيميشن النبض
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _onTextChanged() {
    if (!mounted) return;
    final routeCubit = context.read<RouteCubit>();

    if (_initialLocationName != null &&
        widget.controller.text.trim() != _initialLocationName) {
      if (widget.isFromField) {
        routeCubit.setFromPoint(null);
      } else {
        routeCubit.setToPoint(null);
      }
      setState(() {
        _initialLocationName = null;
      });
    }

    if (widget.isFromField &&
        _initialLocationName == null &&
        widget.controller.text.trim().startsWith("الموقع الحالي")) {
      _setCurrentLocation();
    }

    setState(() {});
  }

  Future<void> _setCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;

    final locationText =
        "الموقع الحالي (${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)})";

    setState(() {
      widget.controller.text = locationText;
      _initialLocationName = locationText;
    });

    final routeCubit = context.read<RouteCubit>();
    if (widget.isFromField) {
      routeCubit.setFromPoint(
        mb.Point(coordinates: mb.Position(pos.longitude, pos.latitude)),
      );
    }

    widget.onSelected(MapSuggestion(
      id: "current_location",
      name: "الموقع الحالي",
      latitude: pos.latitude,
      longitude: pos.longitude,
    ));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeCubit = context.watch<RouteCubit>();
    final bool hasCoordinates = widget.isFromField
        ? routeCubit.fromPoint != null
        : routeCubit.toPoint != null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: GestureDetector(
        onTap: () {
          LocationSearchBottomSheet.show(
            context: context,
            label: widget.label,
            controller: widget.controller,
            onSelected: (suggestion) {
              if (!mounted) return;
              widget.onSelected(suggestion);
              setState(() {
                _initialLocationName = suggestion.name;
              });
            },
            initialLocationName: _initialLocationName ?? "",
          );
        },
        child: AbsorbPointer(
          child: Row(
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 16.w,
                  height: 14.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasCoordinates ? Colors.green : Colors.red,
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
              ),
              horizontalSpace(5),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  validator: widget.validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (_) {
                    Form.of(context).validate();
                  },
                  decoration: InputDecoration(
                    labelText: widget.label,
                    labelStyle: TextStyles.font10BlackMedium(),
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: ColorPalette.red,
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
                      borderSide:
                          BorderSide(color: widget.borderColor, width: 1.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: hasCoordinates ? ColorPalette.green : Colors.red,
                        width: 1.5.w,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          BorderSide(color: widget.borderColor, width: 1.w),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: hasCoordinates ? ColorPalette.green : Colors.red,
                        width: 1.5.w,
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
  }
}
