import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

import 'customer_bid.dart';

class BidBottomSheet extends StatelessWidget {
  const BidBottomSheet({super.key, required this.comingFrom});

  final String comingFrom;

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
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h,),
            Text("Bid", style: jost600(32.sp, AppColors.primary),),
            SizedBox(height: 20.h,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Enter your bid amount", style: jost600(16.sp, AppColors.primary),),
            ),
            SizedBox(height: 15.h,),
            CustomInputField(
                controller: bid,
                label: "Your offer",
                keyboardType: TextInputType.number,
            ),
            SizedBox(height: 21.h,),
            CustomElevatedButton(
                text: comingFrom == "customer" ? "Offer" : "Send Bid",
                fontSize: 16.sp,
                onPressed: (){
                  if(comingFrom == "tech"){
                    Get.back();
                    Get.bottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        enableDrag: true,
                        CustomerBidBottomSheet()
                    );
                  }

                },
            ),
            SizedBox(height: 29.h,),
          ],
        ),
      ),
    );
  }
}
