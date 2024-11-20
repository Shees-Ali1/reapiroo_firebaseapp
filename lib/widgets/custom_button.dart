import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? textColor;
  final BorderSide? borderSide;

  CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.backgroundColor,
    this.textColor,
    this.borderSide,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary, // Default or provided background color
        shape: RoundedRectangleBorder(
          side: borderSide ?? BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 13.31.r), // Border radius
        ),
        minimumSize: Size(width ?? double.infinity, height ?? 51.h), // Use width and height or default
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: text.isEmpty // Show spinner when text is empty
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // White spinner color
        )
            : Text(
          text,
          style: GoogleFonts.jost(
            fontWeight: FontWeight.w500,
            color: textColor ?? AppColors.buttontext, // Default text color
            fontSize: fontSize ?? 19.sp, // Default text size
          ),
        ),
      ),
    );
  }
}
