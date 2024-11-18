import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

// CustomerBidBottomSheet.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerBidBottomSheet extends StatelessWidget {
  final double bidAmount;
  final String bidderId;
  final String customerUid;

  const CustomerBidBottomSheet({
    super.key,
    required this.bidAmount,
    required this.bidderId,
    required this.customerUid,
  });

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
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Customer Bid",
              style: jost600(32.sp, AppColors.primary),
            ),
            SizedBox(height: 38.h),
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
                    bidAmount.toStringAsFixed(2),
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
            SizedBox(height: 29.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  width: 155.w,
                  backgroundColor: AppColors.primary,
                  text: "Accept",
                  textColor: AppColors.secondary,
                  borderSide: const BorderSide(color: Colors.transparent, width: 1),
                  fontSize: 16.sp,
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('JobAccepted')
                          .add({
                        'bidAmount': bidAmount.toStringAsFixed(2),
                        'bidFrom': 'customer',
                        'bidderId': bidderId,
                        'customerUid': customerUid,
                        'message': 'last bid',
                        'timestamp': Timestamp.now(),
                      });

                      // Close the bottom sheet and show a success message
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Bid accepted and job created successfully!',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } catch (e) {
                      // Handle Firestore write errors
                      Get.snackbar(
                        'Error',
                        'Failed to accept bid: $e',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
                CustomElevatedButton(
                  width: 155.w,
                  backgroundColor: const Color(0xffDDDDDD),
                  text: "Bid",
                  textColor: AppColors.primary,
                  borderSide: const BorderSide(color: Colors.transparent, width: 1),
                  fontSize: 16.sp,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
            SizedBox(height: 29.h),
          ],
        ),
      ),
    );
  }
}
