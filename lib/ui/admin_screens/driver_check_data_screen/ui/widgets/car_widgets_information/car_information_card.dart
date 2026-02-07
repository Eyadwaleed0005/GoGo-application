import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CarInformationCard extends StatelessWidget {
  final String carBrand;
  final String carModel;
  final String carColor;
  final String plateNumber;
  final String carPhoto;

  const CarInformationCard({
    super.key,
    required this.carBrand,
    required this.carModel,
    required this.carColor,
    required this.plateNumber,
    required this.carPhoto,
  });

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyles.font10BlackSemiBold(),
          ),
          horizontalSpace(8),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyles.font10BlackSemiBold(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _openFullImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullScreenImage(imageUrl: imageUrl)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("بيانات العربية", style: TextStyles.font15Blackbold()),
            ),
            verticalSpace(12),
            _buildInfoRow("الماركة", carBrand),
            _buildInfoRow("الموديل", carModel),
            _buildInfoRow("اللون", carColor),
            _buildInfoRow("رقم اللوحة", plateNumber),
            verticalSpace(12),
            const Divider(),
            if (carPhoto.isNotEmpty) ...[
              Center(child: Text("صورة العربية", style: TextStyles.font17blackBold())),
              verticalSpace(8),
              GestureDetector(
                onTap: () => _openFullImage(context, carPhoto),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    carPhoto,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
