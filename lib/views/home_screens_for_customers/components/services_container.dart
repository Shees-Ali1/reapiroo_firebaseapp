import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';

class ServicesContainer extends StatefulWidget {
  const ServicesContainer({super.key, required this.image, required this.title});

  final String image;
  final String title;

  @override
  State<ServicesContainer> createState() => _ServicesContainerState();
}

class _ServicesContainerState extends State<ServicesContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.79.h),
        width: 163.12.w,
        height: 150.h,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(widget.image), fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(20.r),
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 140.w,
        height: 36.04.h,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(20.r),
        ),
       alignment: Alignment.center,
        child: Text(widget.title, style: jost700(12.sp, AppColors.primary),),
      ),
    );
  }
}
