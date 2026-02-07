import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialMediaIcon extends StatefulWidget {
  final String iconPath;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;

  const SocialMediaIcon({
    super.key,
    required this.iconPath,
    this.size = 50.0,
    this.iconSize = 30.0,
    this.onTap,
  });

  @override
  State<SocialMediaIcon> createState() => _SocialMediaIconState();
}

class _SocialMediaIconState extends State<SocialMediaIcon>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() {
      _scale = 0.9;
    });
  }

  void _onTapUp(_) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.size.w,
          height: widget.size.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Image.asset(
            widget.iconPath,
            width: widget.iconSize.w,
            height: widget.iconSize.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
