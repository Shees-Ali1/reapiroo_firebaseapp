import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/my_svg.dart';

class CustomBox extends StatefulWidget {
  const CustomBox({super.key, required this.image, required this.title, required this.value});

  final String image;
  final String title;
  final String value;
  
  @override
  State<CustomBox> createState() => _CustomBoxState();
}

class _CustomBoxState extends State<CustomBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(20, 159, 169, 0.24), // Adjust opacity if needed
            offset: Offset(0, 0.86), // (x = 0, y = 4)
            blurRadius: 8.64, // blur 10.4
            spreadRadius: -0.86, // spread 0
          ),
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MySvg(assetName: widget.image, width: 50.w, height: 50.h,),
          SizedBox(height: 5.h,),
          Text(widget.title, style: montserrat700(10.sp, AppColors.secondary),),
          SizedBox(height: 5.h,),
          Container(
            width: 84.w,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(6.w),
            ),
            alignment: Alignment.center,
            child: Text(widget.value, style: montserrat700(12.sp, AppColors.primary),),
          )
        ],
      ),
    );
  }
}
