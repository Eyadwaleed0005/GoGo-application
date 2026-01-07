import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiWrapper extends StatelessWidget {
  final Widget child;
  final SystemUiOverlayStyle style;

  const SystemUiWrapper({
    super.key,
    required this.child,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: child,
    );
  }
}
