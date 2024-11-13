import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color borderColor;
  final String? icon;
  final Color? iconColor;
  final String label;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final VoidCallback onPressed;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? vPadding;
  final bool isLoading;
  const CustomButton(
      {super.key,
      this.height,
      this.width,
      this.borderRadius,
      this.borderColor = AppColors.primary,
      this.icon,
      this.iconColor,
      required this.label,
      this.labelFontSize,
      this.foregroundColor,
      this.backgroundColor,
      required this.onPressed,
      this.isLoading = false,
      this.labelFontWeight,
      this.vPadding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 51.h,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        padding:
            EdgeInsets.symmetric(vertical: vPadding ?? 16.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(borderRadius ?? 13.31.r),
          border: Border.all(color: borderColor),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: foregroundColor ?? AppColors.secondary,
                strokeWidth: 2.w,
              )
            : Text(label,
                style: jost500(labelFontSize ?? 16.sp, foregroundColor ?? AppColors.secondary)),
      ),
    );
  }
}
