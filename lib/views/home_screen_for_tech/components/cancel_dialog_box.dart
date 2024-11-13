import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_container.dart';

class CancelDialogBox extends StatelessWidget {
  const CancelDialogBox({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController reason = TextEditingController();

    return Container(
      width: 250.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 32.h,),
            Text("Do you want to", style: jost600(24.sp, AppColors.primary),),
            Text("Cancel?", style: jost700(26.sp, AppColors.primary),),
            SizedBox(height: 12.h,),
            TextFormField(
              controller: reason,
              cursorColor: AppColors.primary,
              maxLines: 6,
              style: jost400(15.sp, AppColors.primary),
              decoration: InputDecoration(
                hintText: "Write your reason",
                fillColor: AppColors.fill,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.31.r),
                  borderSide: BorderSide(color: AppColors.lightGrey, width: 0.95.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrey, width: 0.95.w),
                  borderRadius: BorderRadius.circular(13.31.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrey, width: 0.95.w),
                  borderRadius: BorderRadius.circular(13.31.r),
                ),
              ),
            ),
            SizedBox(height:17.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                    width: 101.w,
                    height: 42.h,
                    label: "Yes",
                    backgroundColor: AppColors.primary,
                    labelFontSize: 19.sp,
                    borderRadius: 13.31.r,
                    vPadding: 0,
                  onPressed: (){
                      Get.back();
                    },
                ),
                CustomButton(
                    width: 101.w,
                    height: 42.h,
                    label: "No",
                    backgroundColor: Color(0xffDDDDDD),
                    borderColor: AppColors.primary,
                    vPadding: 0,
                    foregroundColor: AppColors.primary,
                    labelFontSize: 19.sp,
                    borderRadius: 13.31.r,
                    onPressed: (){
                      Get.back();
                    },
                ),
              ],
            ),
            SizedBox(height:13.h),
          ],
        ),
      ),
    );
  }
}
