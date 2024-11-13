import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';
import 'package:repairoo/widgets/promo_bottomsheet.dart';

class PaymentBottomsheet extends StatefulWidget {
  const PaymentBottomsheet({super.key, required this.price});

  final String price;

  @override
  State<PaymentBottomsheet> createState() => _PaymentBottomsheetState();
}

class _PaymentBottomsheetState extends State<PaymentBottomsheet> {
  // Define a service fee percentage (e.g., 2%)
  final double serviceFeePercentage = 2.0;

  double get serviceFee {
    return (double.parse(widget.price) * serviceFeePercentage) / 100;
  }

  double get totalAmount {
    return double.parse(widget.price) + serviceFee;
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
            SizedBox(height: 26.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 50.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  Text(
                    "${widget.price}",
                    style: GoogleFonts.inter(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    "AED",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            _buildAmountRow("Amount", widget.price),
            _buildAmountRow("Service Fees ( incl VAT )(${serviceFeePercentage.toStringAsFixed(1)}%)", serviceFee.toStringAsFixed(2)),
            _buildAmountRow("Total", totalAmount.toStringAsFixed(2), isTotal: true),
            SizedBox(height: 30.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Select payment Method.",
                style: jost600(16.sp, AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50.h),
            _buildPaymentOption(AppImages.white_wallet, 'Pay via Wallet'),
            _buildPaymentOption(AppImages.card, 'Pay via Card'),
            _buildPaymentOption(AppImages.apple_pay, 'Apple Pay'),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.bottomSheet(
                  PromoBottomsheet(),
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                );
              },
              child: Text(
                "Use a promo Code",
                style: GoogleFonts.jost(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 29.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: jost600(
              isTotal ? 18.sp : 16.sp,
              isTotal ? AppColors.primary : AppColors.primary,
            ),
          ),
          Text(
            "$value AED",
            style: GoogleFonts.inter(
              fontSize: isTotal ? 18.sp : 16.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String assetPath, String label) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(assetPath, width: 21.w, height: 21.h),
          SizedBox(width: 80.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
