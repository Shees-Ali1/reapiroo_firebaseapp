import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

class PromoBottomsheet extends StatefulWidget {
  const PromoBottomsheet({
    super.key,
  });

  @override
  State<PromoBottomsheet> createState() => _PromoBottomsheetState();
}

class _PromoBottomsheetState extends State<PromoBottomsheet> {
  final TextEditingController promoCodeController = TextEditingController();
  bool isPromoApplied = false;
  double discountAmount = 0.0;
  double totalAmount = 100.0; // Example total amount before discount

  void applyPromoCode() {
    setState(() {
      // Example logic to check the promo code and apply a discount
      if (promoCodeController.text == 'SAVE20') {
        discountAmount = 20.0; // Example discount value
        isPromoApplied = true;
      } else {
        isPromoApplied = false;
        discountAmount = 0.0;
      }
    });
  }

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
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Enter Promo Code",
                style: jost500(19.sp, AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 29.h),
            CustomInputField(
              label: 'Promo Code',
              controller: promoCodeController,
            ),
            SizedBox(height: 33.h),
            CustomElevatedButton(
              text: "Apply",
              fontSize: 16.sp,
              onPressed: () {
                applyPromoCode();
              },
            ),
            if (isPromoApplied) ...[
              SizedBox(height: 20.h),
              Text(
                "Discount Applied: \$${discountAmount.toStringAsFixed(2)}",
                style: jost500(16.sp, Colors.green),
              ),
              SizedBox(height: 10.h),
              Text(
                "Total Left to Pay: \$${(totalAmount - discountAmount).toStringAsFixed(2)}",
                style: jost500(16.sp, AppColors.primary),
              ),
            ],
            SizedBox(height: 12.h),
            CustomElevatedButton(
              backgroundColor: Color(0xffDDDDDD),
              text: "Back",
              textColor: AppColors.primary,
              borderSide: BorderSide(color: Colors.transparent, width: 1),
              fontSize: 16.sp,
              onPressed: () {
                Get.back();
              },
            ),
            SizedBox(height: 29.h),
          ],
        ),
      ),
    );
  }
}
