import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        title: 'Reports',
        isSecondIcon: false,
        onBackTap: () {
          Get.back();
        },
      ),
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.h,),
            Container(
              height: 244.22.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.secondary,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      /// Today Appointment
                      Container(
                        height: 113.76.h,
                        width: 154.43.w,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(7.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundImage:
                                    AssetImage(AppImages.today_appointment),
                              ),
                              Spacer(),
                              Text(
                                "Today Appointments",
                                style: jost700(10.sp, AppColors.secondary),
                              ),
                              Spacer(),
                              Container(
                                height: 20.h,
                                width: 84.w,
                                decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(6.r)),
                                child: Center(
                                  child: Text(
                                    "3",
                                    style: jost700(12.sp, AppColors.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),

                      /// Happy Customers
                      Container(
                        height: 113.76.h,
                        width: 154.43.w,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(7.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundImage:
                                    AssetImage(AppImages.happy_customers),
                              ),
                              Spacer(),
                              Text(
                                "Happy Customers",
                                style: jost700(10.sp, AppColors.secondary),
                              ),
                              Spacer(),
                              Container(
                                height: 20.h,
                                width: 84.w,
                                decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(6.r)),
                                child: Center(
                                  child: Text(
                                    "2000",
                                    style: jost700(12.sp, AppColors.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      /// Jobs Completed
                      Container(
                        height: 113.76.h,
                        width: 154.43.w,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(7.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundImage:
                                    AssetImage(AppImages.jobs_completed),
                              ),
                              Spacer(),
                              Text(
                                "Jobs Completed",
                                style: jost700(10.sp, AppColors.secondary),
                              ),
                              Spacer(),
                              Container(
                                height: 20.h,
                                width: 84.w,
                                decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(6.r)),
                                child: Center(
                                    child: Text(
                                  "170",
                                  style: jost700(12.sp, AppColors.primary),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),

                      /// Total Earned
                      Container(
                        height: 113.76.h,
                        width: 154.43.w,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(7.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundImage:
                                    AssetImage(AppImages.total_earned),
                              ),
                              Spacer(),
                              Text(
                                "Total Earned",
                                style: jost700(10.sp, AppColors.secondary),
                              ),
                              Spacer(),
                              Container(
                                height: 20.h,
                                width: 84.w,
                                decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(6.r)),
                                child: Center(
                                    child: Text(
                                  "\$400",
                                  style: jost700(12.sp, AppColors.primary),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
