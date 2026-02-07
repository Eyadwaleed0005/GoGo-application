import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/logic/cubit/driver_wallet_screen_cubit.dart';

class ProofOfPaymentWidget extends StatelessWidget {
  const ProofOfPaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Proof of payment",
          style: TextStyles.font15Blackbold(),
          textAlign: TextAlign.center,
        ),
        verticalSpace(20),
        BlocBuilder<DriverWalletScreenCubit, DriverWalletScreenState>(
          builder: (context, state) {
            XFile? image = state.images.isNotEmpty ? state.images[0] : null;

            return GestureDetector(
              onTap: () =>
                  context.read<DriverWalletScreenCubit>().pickImage(0),
              child: Container(
                width: double.infinity,
                height: 60.w,
                decoration: BoxDecoration(
                  color: ColorPalette.circlesBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: ColorPalette.textColor1),
                ),
                child: image == null
                    ? Icon(
                        Icons.add,
                        size: 40.sp,
                        color: ColorPalette.fieldStroke,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
