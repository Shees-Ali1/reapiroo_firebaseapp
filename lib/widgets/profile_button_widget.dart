import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';

class ProfileButton extends StatefulWidget {
  final VoidCallback onPressed; // Required onPressed callback
  final String label; // Required label text
  final String iconPath; // Required icon path

  // Constructor with required parameters
  const ProfileButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.iconPath,
  }) : super(key: key);

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed, // Call the provided onPressed function
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent, // No background color
        padding: EdgeInsets.zero, // Remove default padding
        minimumSize: Size(double.infinity, 52.h), // Set height
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(13.31.r), // Border radius
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  widget.iconPath, // Use the passed icon asset path
                  height: 22.54.h, // Set your desired height
                  width: 25.54.w, // Set your desired width
                ),
                SizedBox(width: 20.39.h),
                // Use a fixed color for the text
                Text(
                  widget.label, // Use the passed label text
                  style: jost500(
                    16.sp,
                    Color.fromRGBO(81, 81, 81, 1), // Fixed color, no state-based change
                  ),
                ),
              ],
            ),
            Image.asset(
              AppImages.arrowforward, // Use the image asset path
              height: 14.62.h, // Set your desired height
              width: 24.85.w, // Set your desired width
            ),
          ],
        ),
      ),
    );
  }
}
