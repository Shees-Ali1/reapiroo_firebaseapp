import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';

import '../const/images.dart';

class OtpBackButtonWidget extends StatelessWidget {
  const OtpBackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Image.asset(
                  color: AppColors.secondary,
                  AppImages.bigArrow,
                  scale: 3,
                ),
                Image.asset(
                  color: AppColors.secondary,
                  AppImages.bigArrow,
                  scale: 4.5,
                ),
                SizedBox(
                  width: 9.w,
                ),
                Text(
                  'Back',
                  style: jost600(20.sp, AppColors.secondary),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h,),
        Container(
          height: 0.6.h,
          width: double.infinity,
          color: Color(0xffBCCAD6),
        )
      ],
    );
  }
}
