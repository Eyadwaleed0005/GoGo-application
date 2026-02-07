import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String imagePath;
  final Widget child;
  final bool isAsset; 

  const BackgroundWidget({
    super.key,
    required this.imagePath,
    required this.child,
    this.isAsset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: isAsset
                ? Image.asset(imagePath, fit: BoxFit.cover)
                : Image.network(imagePath, fit: BoxFit.cover),
          ),
          Center(child: child),
        ],
      ),
    );
  }
}
