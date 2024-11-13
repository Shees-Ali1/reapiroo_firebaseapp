import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';
import 'package:repairoo/widgets/payment_bottomsheet.dart';

class JobAcceptedBottomsheet extends StatefulWidget {
  const JobAcceptedBottomsheet({super.key, required this.name, required this.price});

  final String name;
  final String price;

  @override
  State<JobAcceptedBottomsheet> createState() => _JobAcceptedBottomsheetState();
}

class _JobAcceptedBottomsheetState extends State<JobAcceptedBottomsheet> {
  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h,),
            Image.asset(AppImages.black_tick, width: 52.5.w, height: 52.5.h,),
            SizedBox(height: 21.h,),
            Text("Job Accepted", style: jost600(32.sp, AppColors.primary),),
            SizedBox(height: 20.h,),
            Align(
              alignment: Alignment.center,
              child: Text("Your Request has been successfully accepted with ${widget.name}. ", style: jost600(16.sp, AppColors.primary), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 20.h,),
            Align(
              alignment: Alignment.center,
              child: Text("Please continue to payment ", style: jost600(16.sp, AppColors.primary),),
            ),
            SizedBox(height: 35.h,),
            CustomElevatedButton(
              text: "Pay",
              fontSize: 16.sp,
              onPressed: (){
                Get.back();
                Get.bottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                    PaymentBottomsheet(price: widget.price,)
                );

              },
            ),
            SizedBox(height: 29.h,),
          ],
        ),
      ),
    );
  }
}
