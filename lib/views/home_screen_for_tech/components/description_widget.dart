import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/color.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({Key? key}) : super(key: key);

  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 16.sp, // Larger font size for easier readability
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String descriptionText =
        "I need to have my outdoor pipes fixed. We have a huge leakage in the valves and the wall fittings.";

    return GestureDetector(
      onTap: () => _showDialog(context, descriptionText),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          descriptionText,
          style: GoogleFonts.montserrat(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
