import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIconWidget extends StatelessWidget {
  final IconData icon;
  final String url;
  final Color color;
  final double size;

  const SocialIconWidget({
    super.key,
    required this.icon,
    required this.url,
    this.color = Colors.white,
    this.size = 30,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(50.r),
      child: Icon(
        icon,
        color: color,
        size: size.sp,
      ),
    );
  }
}
