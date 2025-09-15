import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'full_screen_image.dart';

class ChargeImageWidget extends StatelessWidget {
  final String imageUrl;

  const ChargeImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImage(imageUrl: imageUrl),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          height: 120.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
