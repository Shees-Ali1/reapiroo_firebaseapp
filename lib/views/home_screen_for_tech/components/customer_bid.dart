import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

class CustomerBidBottomSheet extends StatelessWidget {
  const CustomerBidBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController bid = TextEditingController();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.w),
          topRight: Radius.circular(40.w),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h,),
            Text("Customer Bid", style: jost600(32.sp, AppColors.primary),),
            SizedBox(height: 38.h,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 50.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.h,),
                  Text(
                    "79.00",
                    style: GoogleFonts.inter(
                        fontSize: 38.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary
                    ),
                  ),
                  Text(
                    "AED",
                    style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 29.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              CustomElevatedButton(
                width: 155.w,
                backgroundColor: AppColors.primary,
                text: "Accept",
                textColor: AppColors.secondary,
                borderSide: BorderSide(color: Colors.transparent,width: 1),
                fontSize: 16.sp,
                onPressed: () {
                  Get.back();
                },
              ),
                CustomElevatedButton(
                width: 155.w,
                backgroundColor: Color(0xffDDDDDD),
                text: "Bid",
                textColor: AppColors.primary,
                borderSide: BorderSide(color: Colors.transparent,width: 1),
                fontSize: 16.sp,
                onPressed: () {
                  Get.back();
                },
              ),
            ],),


            SizedBox(height: 29.h,),
          ],
        ),
      ),
    );
  }
}
