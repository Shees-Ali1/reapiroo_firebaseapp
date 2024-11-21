// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:repairoo/const/color.dart';
// import 'package:repairoo/const/text_styles.dart';
// import 'package:repairoo/widgets/custom_button.dart';
// import 'package:repairoo/widgets/custom_input_fields.dart';
//
// // CustomerBidBottomSheet.dart
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CustomerBidBottomSheet extends StatelessWidget {
//   final double bidAmount;
//   final String bidderId;
//   final String customerUid;
//
//   const CustomerBidBottomSheet({
//     super.key,
//     required this.bidAmount,
//     required this.bidderId,
//     required this.customerUid,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppColors.secondary,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(40.w),
//           topRight: Radius.circular(40.w),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.0.w),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(height: 10.h),
//             Text(
//               "Customer Bid",
//               style: jost600(32.sp, AppColors.primary),
//             ),
//             SizedBox(height: 38.h),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 50.w),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(12.w),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: 12.h),
//                   Text(
//                     bidAmount.toStringAsFixed(2),
//                     style: GoogleFonts.inter(
//                       fontSize: 38.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.secondary,
//                     ),
//                   ),
//                   Text(
//                     "AED",
//                     style: GoogleFonts.inter(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.secondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 29.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomElevatedButton(
//                   width: 155.w,
//                   backgroundColor: AppColors.primary,
//                   text: "Accept",
//                   textColor: AppColors.secondary,
//                   borderSide: const BorderSide(color: Colors.transparent, width: 1),
//                   fontSize: 16.sp,
//                   onPressed: () async {
//                     try {
//                       await FirebaseFirestore.instance
//                           .collection('JobAccepted')
//                           .add({
//                         'bidAmount': bidAmount.toStringAsFixed(2),
//                         'bidFrom': 'customer',
//                         'bidderId': bidderId,
//                         'customerUid': customerUid,
//                         'message': 'last bid',
//                         'timestamp': Timestamp.now(),
//                       });
//
//                       // Close the bottom sheet and show a success message
//                       Get.back();
//                       Get.snackbar(
//                         'Success',
//                         'Bid accepted and job created successfully!',
//                         backgroundColor: Colors.green,
//                         colorText: Colors.white,
//                       );
//                     } catch (e) {
//                       // Handle Firestore write errors
//                       Get.snackbar(
//                         'Error',
//                         'Failed to accept bid: $e',
//                         backgroundColor: Colors.red,
//                         colorText: Colors.white,
//                       );
//                     }
//                   },
//                 ),
//                 CustomElevatedButton(
//                   width: 155.w,
//                   backgroundColor: const Color(0xffDDDDDD),
//                   text: "Bid",
//                   textColor: AppColors.primary,
//                   borderSide: const BorderSide(color: Colors.transparent, width: 1),
//                   fontSize: 16.sp,
//                   onPressed: () {
//                     Get.back();
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 29.h),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';
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
                    await _acceptBid(context);
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

  /// Helper function to accept a bid, maintain JobAccepted functionality,
  /// and also move the task to the CompletedTasks collection
  Future<void> _acceptBid(BuildContext context) async {
    try {
      // Step 1: Accept the bid and create a job in 'JobAccepted'
      await FirebaseFirestore.instance.collection('JobAccepted').add({
        'bidAmount': bidAmount.toStringAsFixed(2),
        'name': 'customer',
        'bidderId': bidderId,
        'customerUid': customerUid,
        'message': 'last bid',
        'timestamp': Timestamp.now(),
      });

      // Step 2: Store a notification in the 'techNotifications' collection
      await FirebaseFirestore.instance.collection('techNotifications').add({
        'customerUid': customerUid,
        'techUid': FirebaseAuth.instance.currentUser!.uid, // Current user ID
        'bidAmount': bidAmount.toStringAsFixed(2),
        'message': 'Bid accepted ',
        'timestamp': Timestamp.now(),
      });

      // Step 3: Fetch the tasks collection to find the task associated with the customerUid
      final QuerySnapshot tasksSnapshot = await FirebaseFirestore.instance.collection('tasks').get();

      // Step 4: Iterate through tasks to find a matching customerUid
      for (var doc in tasksSnapshot.docs) {
        final taskData = doc.data() as Map<String, dynamic>;

        // Iterate through each key (which holds an array) to find the matching task
        taskData.forEach((key, value) async {
          if (key != "userUid" && value is List) {
            for (var task in List<Map<String, dynamic>>.from(value)) {
              if (task['userUid'] == customerUid) {
                // Step 5: Remove the task from the original list
                value.remove(task);

                // Step 6: Update the original document to reflect the task removal
                await doc.reference.update({key: value});

                // Step 7: Add the removed task to a new collection (e.g., 'CompletedTasks')
                task['customerUid'] = customerUid;
                task['bidderid'] = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance.collection('CompletedTasks').add({
                  'completedTask': task,
                  'timestamp': Timestamp.now(),
                  'title': key,
                });

                // Notify the user about task transfer
                Get.snackbar(
                  'Success',
                  'Task moved to CompletedTasks successfully!',
                  backgroundColor: Colors.grey,
                  colorText: Colors.white,
                );

                // Task found and moved, break out of the loop
                return;
              }
            }
          }
        });
      }

      // Step 8: Notify the user about the successful bid acceptance
      Get.back();
      Get.snackbar(
        'Success',
        'Bid accepted, Sucessfully!',
        backgroundColor: Colors.grey,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle Firestore errors
      Get.snackbar(
        'Error',
        'Failed to accept bid or process task: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}
