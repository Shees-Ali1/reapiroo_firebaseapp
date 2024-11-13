import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

class SparepartDialogueBox extends StatelessWidget {
   SparepartDialogueBox({super.key});
  final TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus(); // Hide keyboard when tapping outside
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Spare Parts",
              style: jost700(18.sp, AppColors.primary),
            ),
            SizedBox(
              height: 10.h,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r), // Apply circular border radius
              child: Image.asset(
                AppImages.dialogue_boximage,
                width: 233.w,
                height: 175.h,
                fit: BoxFit.contain, // Ensures the image covers the entire area within the border radius
              ),
            ),

            SizedBox(
              height: 16.h,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Have you bought it?",
                  style: jost400(16.sp, AppColors.primary),
                ),
                SizedBox(width: 8.w),
                Row(
                  children: [
                    /// Yes Button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30.h,
                        width: 52.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                            child: Text(
                          "Yes",
                          style: jost600(10.sp, AppColors.secondary),
                        )),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    /// No Button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30.h,
                        width: 52.w,
                        decoration: BoxDecoration(
                          color: AppColors.buttonGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                            child: Text(
                          "No",
                          style: jost600(10.sp, AppColors.buttontext),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 17.h,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upload Invoice of spare part",
                  style: jost400(16.sp, AppColors.primary),
                ),
                SizedBox(width: 8.w),
                /// Upload
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            children: [
                              Image.asset(AppImages.upload_icon,height: 18.h,width: 18.w,),
                              SizedBox(width: 8.w),
                              Text(
                                "Upload",
                                style: jost600(10.sp, AppColors.secondary),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload the invoice as a proof of your purchase",
                style: jost400(10.sp, AppColors.textGrey),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomInputField(
              controller: amount,
              label: 'Enter Amount',
            ),
            SizedBox(
              height: 22.h,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Done Button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 42.h,
                    width: 101.66.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(13.31.r),
                    ),
                    child: Center(
                        child: Text(
                          "Done",
                          style: jost500(19.sp, AppColors.secondary),
                        )),
                  ),
                ),
                SizedBox(width: 10.68.w),
                /// Cancel Button
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 42.h,
                    width: 101.66.w,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGrey,
                      border: Border.all(
                        color: AppColors.buttonborder,
                      ),
                      borderRadius: BorderRadius.circular(13.31.r),
                    ),
                    child: Center(
                        child: Text(
                          "Cancel",
                          style: jost500(19.sp, AppColors.primary),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
